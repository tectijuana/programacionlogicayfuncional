// Prolog Lab — terminal (toplevel emulado), reproductor, editor, árbol SLD.
(() => {
'use strict';
const CDN = 'https://cdn.jsdelivr.net/npm/swipl-wasm@8.2.5/dist/swipl/';
const $ = s => document.querySelector(s);
const sleep = ms => new Promise(r => setTimeout(r, ms));
const esc = s => s.replace(/[&<>"]/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]));
const A = { dim: '\x1b[90m', green: '\x1b[32m', bgreen: '\x1b[1;32m', red: '\x1b[31m', yellow: '\x1b[33m',
            cyan: '\x1b[36m', bold: '\x1b[1m', x: '\x1b[0m' };
const crlf = s => s.replace(/\r?\n/g, '\r\n');

const FUTURO = [];  // [n, titulo, subtitulo, local] niveles aún no escritos

// ---------- persistencia ----------------------------------------------
const store = (() => {
  let st = { done: {}, drafts: {}, last: '1' };
  try { Object.assign(st, JSON.parse(localStorage.getItem('prologlab.v1') || '{}')); } catch (e) {}
  return { st, save() { try { localStorage.setItem('prologlab.v1', JSON.stringify(st)); } catch (e) {} } };
})();

let PL = null;            // instancia swipl-wasm
let L = null;             // lección actual
const LS = window.LECCIONES;

// ---------- terminal --------------------------------------------------
const term = new Terminal({
  fontFamily: "'JetBrains Mono', Menlo, monospace", fontSize: 13.5, lineHeight: 1.25,
  cursorBlink: true, convertEol: false, scrollback: 5000, allowProposedApi: false,
  theme: { background: '#0d1117', foreground: '#c9d1d9', cursor: '#3fb950', selectionBackground: '#264f78',
           black: '#484f58', red: '#ff7b72', green: '#3fb950', yellow: '#d29922', blue: '#58a6ff',
           magenta: '#bc8cff', cyan: '#39c5cf', white: '#b1bac4', brightBlack: '#6e7681' },
});
const fit = new FitAddon.FitAddon();
term.loadAddon(fit);
term.open($('#term'));
const refit = () => { try { fit.fit(); } catch (e) {} };
new ResizeObserver(refit).observe($('#term'));
refit();

const PROMPT = A.bgreen + '?-' + A.x + ' ';
const CONT = A.dim + '|' + A.x + '    ';
const T = { buf: '', pos: 0, pending: '', hist: [], hidx: 0, mode: 'boot', q: null, moreRes: null };

function out(s) { term.write(crlf(s) + '\r\n'); }
function prompt() { T.mode = 'input'; T.buf = ''; T.pos = 0; T.pending = ''; term.write(PROMPT); }
function redraw() {
  term.write('\r\x1b[K' + (T.pending ? CONT : PROMPT) + T.buf);
  const back = T.buf.length - T.pos;
  if (back > 0) term.write(`\x1b[${back}D`);
}
function insert(s) { T.buf = T.buf.slice(0, T.pos) + s + T.buf.slice(T.pos); T.pos += s.length; redraw(); }

term.onData(d => {
  if (Player.playing) Player.stop(true);
  if (T.mode === 'more') { moreKey(d); return; }
  if (T.mode !== 'input') return;
  if (d === '\x1b[A') { if (T.hidx > 0) { T.buf = T.hist[--T.hidx]; T.pos = T.buf.length; redraw(); } return; }
  if (d === '\x1b[B') { if (T.hidx < T.hist.length) { T.hidx++; T.buf = T.hist[T.hidx] || ''; T.pos = T.buf.length; redraw(); } return; }
  if (d === '\x1b[D') { if (T.pos > 0) { T.pos--; term.write(d); } return; }
  if (d === '\x1b[C') { if (T.pos < T.buf.length) { T.pos++; term.write(d); } return; }
  if (d === '\x1b[H' || d === '\x01') { T.pos = 0; redraw(); return; }
  if (d === '\x1b[F' || d === '\x05') { T.pos = T.buf.length; redraw(); return; }
  if (d.startsWith('\x1b')) return;
  for (const ch of d.replace(/\r\n/g, '\r').replace(/\n/g, '\r')) {
    if (ch === '\r') enter();
    else if (ch === '\x7f' || ch === '\b') { if (T.pos > 0) { T.buf = T.buf.slice(0, T.pos - 1) + T.buf.slice(T.pos); T.pos--; redraw(); } }
    else if (ch === '\x03') { term.write('^C\r\n'); prompt(); }
    else if (ch === '\x0c') { term.clear(); redraw(); }
    else if (ch === '\t') insert('    ');
    // ; o . sueltos en prompt vacío (alumno pide "otra" cuando ya no hay): se ignoran
    else if ((ch === ';' || ch === '.') && !T.buf && !T.pending) continue;
    else if (ch >= ' ') insert(ch);
    if (T.mode !== 'input') break;
  }
});

function enter() {
  term.write('\r\n');
  const full = (T.pending ? T.pending + '\n' : '') + T.buf;
  if (!full.trim()) { prompt(); return Promise.resolve(); }
  if (!/\.\s*$/.test(full.replace(/%.*$/gm, ''))) {
    T.pending = full; T.buf = ''; T.pos = 0; term.write(CONT); return Promise.resolve();
  }
  if (T.hist[T.hist.length - 1] !== full) T.hist.push(full);
  T.hidx = T.hist.length;
  return runQuery(full, !Player.playing);  // valida retos salvo en la demo
}

function moreKey(d) {
  if (!T.moreRes) return;
  const r = T.moreRes;
  if (';nr \t'.includes(d)) { T.moreRes = null; r(';'); }
  else if ('.\rca\x03'.includes(d)) { T.moreRes = null; r('.'); }
  else if (d === 'h' || d === '?') term.write(A.dim + ' [; o espacio = siguiente · . o Enter = terminar]' + A.x + ' ');
}

const isConsult = s => {
  const m = s.trim().match(/^(?:\[\s*'?([\w\/.]+?)(?:\.pl)?'?\s*\]|consult\(\s*'?([\w\/.]+?)(?:\.pl)?'?\s*\)|(make))\s*\.$/);
  return m && (m[3] || m[1] || m[2]);
};

async function runQuery(src, user) {
  T.mode = 'busy';
  const s = src.trim();
  const tgt = isConsult(s);
  if (/^halt\s*(\(\s*\d*\s*\))?\s*\.$/.test(s)) {
    out(A.dim + '% En el navegador Prolog no se cierra. Usa ⟲ o cambia de lección.' + A.x);
    term.write('\r\n'); prompt(); return;
  }
  if (tgt) writeProgram();
  await sleep(15);
  const goal = tgt === 'make' ? `consult('/${L.archivo}.pl').` : s;
  let err = false;
  try {
    T.q = PL.prolog.query('lab:lab_solve(S, K, O)', { S: goal });
    for (;;) {
      const r = T.q.next();
      flush();
      if (!r.value) { term.write(A.red + 'false' + A.x + '.\r\n'); break; }
      const { K, O } = r.value;
      if (K === 'error') { err = true; out(colorErr(String(O)) + synHint(s, String(O))); break; }
      term.write(colorAns(String(O)));
      if (r.done || K === 'det') { term.write('.\r\n'); break; }
      term.write(' ');
      T.mode = 'more';
      const k = await new Promise(res => (T.moreRes = res));
      T.mode = 'busy';
      if (k === '.') { term.write('.\r\n'); break; }
      term.write(';\r\n');
      await sleep(15);
    }
  } catch (e) {
    out(A.red + 'ERROR (JS): ' + (e.message || e) + A.x);
  } finally {
    try { T.q && T.q.close(); } catch (e) {}
    T.q = null;
  }
  term.write('\r\n');
  if (tgt) checkProgramRetos();
  else if (user && !err) checkQueryRetos(s);
  prompt();
}

const colorAns = s => s === 'true' ? A.green + 'true' + A.x : crlf(s);
const colorErr = s => s.split('\n').map(l => A.red + l + A.x).join('\n');
// pista para errores de sintaxis típicos de principiante
function synHint(src, msg) {
  if (!/Syntax error/.test(msg)) return '';
  const h = /(^|[\s,(])[A-Z_]\w*\(/.test(src) ? 'Los nombres de predicado van en minúscula: padre(...), no Padre(...).'
    : /[a-z]\w*\s+\(/.test(src) ? 'Sin espacio entre el nombre y el paréntesis: padre(juan, X).'
    : /\w\s+[A-Za-z_]/.test(src.replace(/'[^']*'|"[^"]*"/g, '')) && !/\b(is|mod|rem|xor|rdiv|div)\b/.test(src) ? 'Falta una coma entre metas o argumentos.'
    : '';
  return h ? `\n${A.yellow}% Pista: ${h}${A.x}` : '';
}
function flush() { try { PL.prolog.query('lab:lab_flush').once(); } catch (e) {} }

// ---------- reproductor (estilo asciinema) ---------------------------
const SPEEDS = [1, 2, 4, 0.5];
const Player = {
  i: 0, playing: false, driving: false, token: 0, speed: 1,
  get steps() { return L.demo; },
  ui() {
    $('#pPlay').textContent = this.playing ? '⏸ Pausa' : (this.i >= this.steps.length ? '⟲ Repetir' : (this.i ? '▶ Seguir' : '▶ Demo'));
    $('#timeline').style.width = (100 * this.i / this.steps.length) + '%';
  },
  async play() {
    if (this.playing || T.mode === 'boot') return;
    if (this.i >= this.steps.length) return this.restart(true);
    this.playing = true; this.ui();
    const tok = ++this.token;
    while (this.playing && tok === this.token && this.i < this.steps.length) {
      await this.run(this.steps[this.i], tok);
      if (tok !== this.token) return;
      this.i++; this.ui();
      await this.wait(500);
    }
    if (tok === this.token) { this.playing = false; this.ui(); }
  },
  stop(user) {
    if (!this.playing) return;
    this.playing = false; this.token++; this.driving = false; this.ui();
    if (user && T.mode === 'input' && T.buf && !T.pending) { T.buf = ''; T.pos = 0; redraw(); }
  },
  restart(autoplay) {
    this.stop(); this.i = 0; this.ui();
    resetTerminal();
    if (autoplay) this.play();
  },
  wait(ms) { return sleep(ms / this.speed); },
  async idle() { while (T.mode === 'busy') await sleep(30); },
  async type(text, tok, cps = 28) {
    for (const ch of text) {
      if (tok !== this.token) return false;
      insert(ch);
      await this.wait(1000 / cps * (0.6 + Math.random() * 0.8));
    }
    return true;
  },
  async ensureInput() {
    if (T.mode === 'more') { moreKey('.'); await this.idle(); }
    await this.idle();
  },
  async run(st, tok) {
    await this.ensureInput();
    this.driving = true;
    try {
      if (st.c) {
        term.write('\r\x1b[K' + A.dim + '% ');
        for (const ch of st.c) { if (tok !== this.token) return; term.write(ch); await this.wait(14); }
        term.write(A.x + '\r\n'); redraw();
      } else if (st.q || st.consult) {
        const text = st.q || `[${L.archivo}].`;
        if (!(await this.type(text, tok))) return;
        await this.wait(350);
        const p = enter();
        await sleep(30); await this.idle();
        for (let k = 0; k < (st.more || 0) && T.mode === 'more'; k++) {
          await this.wait(1100); if (tok !== this.token) return;
          moreKey(';'); await sleep(30); await this.idle();
        }
        if (T.mode === 'more') { await this.wait(900); if (tok !== this.token) return; moreKey('.'); }
        await p;
      } else if (st.tree) {
        showView('tree');
        $('#treeQ').value = st.tree; $('#treeMax').value = String(st.max || 1);
        await Tree.draw(st.tree, st.max || 1, () => tok === this.token);
        await this.wait(800);
      }
    } finally { this.driving = false; }
  },
};
$('#pPlay').onclick = () => Player.playing ? Player.stop() : Player.play();
$('#pRestart').onclick = () => Player.restart(true);
$('#pNext').onclick = () => {
  if (Player.i >= Player.steps.length) return;
  if (Player.playing) { Player.stop(); }
  Player.play().then(() => {});
  const want = Player.i + 1;
  const iv = setInterval(() => { if (Player.i >= want || !Player.playing) { Player.stop(); clearInterval(iv); } }, 50);
};
$('#pSpeed').onclick = () => {
  Player.speed = SPEEDS[(SPEEDS.indexOf(Player.speed) + 1) % SPEEDS.length];
  $('#pSpeed').textContent = (Player.speed === 0.5 ? '½' : Player.speed) + '×';
};

function resetTerminal() {
  if (T.moreRes) moreKey('.');
  term.reset();
  const v = PL.version;
  out(`${A.bold}Prolog Lab${A.x}${A.dim} · SWI-Prolog ${v} (WebAssembly) · ${L.archivo}.pl${A.x}`);
  out(`${A.dim}Nivel ${L.nivel} — ${L.titulo}: ${L.tema}${A.x}`);
  out(`${A.dim}Pulsa ${A.x}▶ Demo${A.dim} para ver la lección, o escribe consultas tras ${A.x}${A.bgreen}?-${A.x}${A.dim}.${A.x}`);
  out(`${A.dim}${A.cyan};${A.dim} siguiente solución · ${A.cyan}.${A.dim} terminar · ${A.cyan}↑↓${A.dim} historial · ${A.cyan}Ctrl+L${A.dim} limpiar · ${A.cyan}[${L.archivo}].${A.dim} consulta el editor${A.x}`);
  // carga el programa del editor para que los retos funcionen sin pulsar Demo/Consultar
  writeProgram();
  try { PL.prolog.query(`consult('/${L.archivo}.pl')`).once(); } catch (e) {}
  flush();
  out(`${A.dim}% ${L.archivo}.pl ya está consultado.${A.x}`);
  term.write('\r\n');
  prompt();
}

// ---------- editor ----------------------------------------------------
const srcEl = $('#src'), hlEl = $('#hl'), gutEl = $('#gutter');
const HL = /(%.*$)|(\/\*[\s\S]*?\*\/)|("(?:[^"\\\n]|\\.)*")|('(?:[^'\\\n]|\\.)*')|(\b[A-Z_][A-Za-z0-9_]*)|(\b\d+(?:\.\d+)?\b)|(:-|-->|\\\+|=\\=|=:=|\\==|\\=|==|=<|>=|\bis\b|->|;|!)|(\b[a-z][A-Za-z0-9_]*(?=\())/gm;
const CLS = [, 'h-com', 'h-com', 'h-str', 'h-str', 'h-var', 'h-num', 'h-op', 'h-fun'];
function highlight() {
  const s = srcEl.value; let h = '', last = 0;
  s.replace(HL, (m, ...g) => {
    const off = g[g.length - 2];
    const k = g.slice(0, 8).findIndex(x => x !== undefined) + 1;
    h += esc(s.slice(last, off)) + `<span class="${CLS[k]}">${esc(m)}</span>`;
    last = off + m.length; return m;
  });
  hlEl.innerHTML = h + esc(s.slice(last)) + '\n';
  const n = s.split('\n').length;
  gutEl.textContent = Array.from({ length: n }, (_, i) => i + 1).join('\n');
  syncScroll();
}
function syncScroll() { hlEl.scrollTop = srcEl.scrollTop; hlEl.scrollLeft = srcEl.scrollLeft; gutEl.scrollTop = srcEl.scrollTop; }
srcEl.addEventListener('scroll', syncScroll);
srcEl.addEventListener('input', () => { highlight(); store.st.drafts[L.id] = srcEl.value; store.save(); });
srcEl.addEventListener('keydown', e => {
  if (e.key === 'Tab') { e.preventDefault(); document.execCommand('insertText', false, '    '); }
  if (e.key === 'Enter' && (e.ctrlKey || e.metaKey)) { e.preventDefault(); consultEditor(); }
});
function writeProgram() { PL.FS.writeFile(`/${L.archivo}.pl`, srcEl.value); }
let consultando = false;  // evita dos consultas tecleándose a la vez (doble clic mientras la terminal está ocupada)
async function consultEditor() {
  if (T.mode === 'boot' || consultando) return;
  consultando = true;
  try {
    Player.stop();
    if (T.mode === 'more') moreKey('.');
    await Player.idle();
    if (T.mode !== 'input') return;
    T.buf = ''; T.pos = 0; redraw();
    Player.driving = true;
    const tok = Player.token;
    await Player.type(`[${L.archivo}].`, tok, 140);
    Player.driving = false;
    await enter();
    term.focus();
  } finally { consultando = false; }
}
$('#btnConsult').onclick = consultEditor;
$('#btnReset').onclick = () => {
  if (srcEl.value !== L.programa && !confirm('¿Restaurar el programa original? Se pierden tus cambios en el editor.')) return;
  srcEl.value = L.programa; delete store.st.drafts[L.id]; store.save(); highlight();
};

// ---------- tabs ------------------------------------------------------
function showView(v) {
  document.querySelectorAll('.tab').forEach(t => t.classList.toggle('active', t.dataset.view === v));
  document.querySelectorAll('.view').forEach(x => x.classList.toggle('active', x.id === 'view-' + v));
  $('#editorActions').style.visibility = v === 'editor' ? 'visible' : 'hidden';
}
document.querySelectorAll('.tab').forEach(t => (t.onclick = () => showView(t.dataset.view)));

// ---------- árbol SLD -------------------------------------------------
// primera meta de un resolvente "a(X, b), c" -> "a(X, b)"
function first(s) { let d = 0; for (let i = 0; i < s.length; i++) { const c = s[i];
  if ('([{'.includes(c)) d++; else if (')]}'.includes(c)) d--; else if (c === ',' && d === 0) return s.slice(0, i); } return s; }
const SLOT = 168, ROW = 74, NW = 156, NH = 30, MAXC = 22;
const Tree = {
  nodes: null, order: [], k: 0, playing: false, gen: 0, last: 0, stats: null,
  async draw(src, max, alive = () => true) {
    const gen = ++this.gen;
    src = src.trim().replace(/\.\s*$/, '');
    if (!src) return;
    writeProgram();
    let res;
    try {
      res = PL.prolog.query('lab:lab_tree(S, M, O)', { S: src + '.', M: max }).once();
    } catch (e) { res = null; }
    flush();
    if (!res || !res.O && res.O !== '') { this.status('No se pudo analizar la consulta (¿error de sintaxis?).', 'bad'); return; }
    this.parse(String(res.O));
    this.layout();
    this.render();
    this.playing = true; $('#treePlay').textContent = '⏸';
    while (this.k < this.order.length && gen === this.gen) {
      if (!alive()) { this.playing = false; break; }
      if (!this.playing) { await sleep(80); continue; }
      const ev = this.order[this.k++];
      this.apply(ev);
      await sleep((ev.t === 'sol' ? 1400 : ev.t === 'dead' ? 520 : 380) / Player.speed);
    }
    if (gen === this.gen) { this.playing = false; $('#treePlay').textContent = '▶'; if (this.k >= this.order.length) this.finish(); }
  },
  parse(txt) {
    this.nodes = new Map(); this.order = []; this.k = 0; this.last = 0; this.limit = false;
    this.stats = { n: 0, f: 0, b: 0, s: 0 };
    for (const line of txt.split('\n')) {
      if (!line) continue;
      const p = line.split('|');
      if (p[0] === 'node') {
        const n = { id: +p[1], parent: +p[2], label: p.slice(3).join('|'), kids: [] };
        this.nodes.set(n.id, n);
        const par = this.nodes.get(n.parent); if (par) par.kids.push(n);
        this.order.push({ t: 'node', id: n.id });
      } else if (p[0] === 'dead') this.order.push({ t: 'dead', id: +p[1] });
      else if (p[0] === 'sol') { this.nodes.get(+p[1]).ans = p.slice(2).join('|'); this.order.push({ t: 'sol', id: +p[1] }); }
      else if (p[0] === 'limit') this.limit = true;
    }
  },
  layout() {
    let leaf = 0, depth = 0;
    const place = (n, d) => {
      n.d = d; depth = Math.max(depth, d);
      if (!n.kids.length) n.x = leaf++;
      else { n.kids.forEach(k => place(k, d + 1)); n.x = (n.kids[0].x + n.kids[n.kids.length - 1].x) / 2; }
    };
    const root = this.nodes.get(1);
    if (root) place(root, 0);
    this.W = Math.max(1, leaf) * SLOT + 24; this.H = (depth + 1) * ROW + 40;
  },
  pos(n) { return { x: 12 + n.x * SLOT + SLOT / 2, y: 20 + n.d * ROW }; },
  render() {
    const wrap = $('#treeWrap');
    $('#treeEmpty').style.display = this.nodes.size ? 'none' : '';
    wrap.querySelector('svg')?.remove();
    if (!this.nodes.size) { this.status('Sin nodos.', 'bad'); return; }
    let edges = '', nodes = '';
    for (const n of this.nodes.values()) {
      const { x, y } = this.pos(n);
      const par = this.nodes.get(n.parent);
      if (par) {
        const p = this.pos(par), y0 = p.y + NH, my = (y0 + y) / 2;
        edges += `<path class="te hidden" id="te${n.id}" d="M${p.x},${y0} C${p.x},${my} ${x},${my} ${x},${y}"/>`;
      }
      const isSol = n.label === '□';
      const lbl = isSol ? '□  éxito' : (n.label.length > MAXC ? n.label.slice(0, MAXC - 1) + '…' : n.label);
      nodes += `<g class="tn hidden" id="tn${n.id}" transform="translate(${x - NW / 2},${y})"><title>${esc(n.label)}</title>` +
        `<rect width="${NW}" height="${NH}" rx="7"/><text x="${NW / 2}" y="19.5" text-anchor="middle">${esc(lbl)}</text>` +
        `<text class="mark" x="${NW - 4}" y="-4" text-anchor="end"></text>` +
        (n.ans ? `<text class="ans" x="${NW / 2}" y="${NH + 15}" text-anchor="middle">${esc(n.ans.length > 26 ? n.ans.slice(0, 25) + '…' : n.ans)}<title>${esc(n.ans)}</title></text>` : '') +
        `</g>`;
    }
    wrap.insertAdjacentHTML('beforeend', `<svg class="tree" width="${this.W}" height="${this.H}" viewBox="0 0 ${this.W} ${this.H}">${edges}${nodes}</svg>`);
    this.paintStats();
    this.status('Explorando…');
  },
  el(id) { return document.getElementById('tn' + id); },
  apply(ev) {
    const n = this.nodes.get(ev.id), g = this.el(ev.id);
    document.querySelectorAll('.tn.active, .tn.bt').forEach(x => x.classList.remove('active', 'bt'));
    if (ev.t === 'node') {
      g.classList.remove('hidden'); document.getElementById('te' + ev.id)?.classList.remove('hidden');
      g.classList.add('active'); this.stats.n++;
      if (n.parent && this.last && this.last !== n.parent) {
        this.stats.b++;
        const par = this.el(n.parent); par.classList.add('bt');
        this.status(`↩ retroceso a «${first(this.nodes.get(n.parent).label)}» · siguiente alternativa`, 'bt');
      } else this.status(n.label === '□' ? '□ todas las metas resueltas' : `meta: ${first(n.label)}`);
      this.last = ev.id;
      this.scrollTo(n);
    } else if (ev.t === 'dead') {
      g.classList.add('dead'); g.querySelector('.mark').textContent = '✗'; this.stats.f++;
      this.status(`✗ falla: ${first(n.label)} no tiene solución`, 'bad');
    } else if (ev.t === 'sol') {
      g.classList.add('sol'); this.stats.s++;
      this.status(`✓ solución ${this.stats.s}: ${n.ans}`, 'ok');
    }
    this.paintStats();
  },
  finish() {
    this.status(this.limit ? `Árbol truncado a 400 nodos · ${this.stats.s} solución(es)`
      : `Fin · ${this.stats.n} nodos, ${this.stats.f} fallos, ${this.stats.b} retrocesos, ${this.stats.s} solución(es)`, this.stats.s ? 'ok' : 'bad');
  },
  showAll() {
    if (!this.nodes) return;
    this.gen++;
    while (this.k < this.order.length) this.apply(this.order[this.k++]);
    this.playing = false; $('#treePlay').textContent = '▶'; this.finish();
  },
  scrollTo(n) {
    const w = $('#treeWrap'), { x, y } = this.pos(n);
    const tx = x - w.clientWidth / 2, ty = y - w.clientHeight / 2;
    if (Math.abs(w.scrollLeft - tx) > w.clientWidth / 3 || Math.abs(w.scrollTop - ty) > w.clientHeight / 3)
      w.scrollTo({ left: tx, top: ty, behavior: 'smooth' });
  },
  status(t, cls = '') { const s = $('#treeStatus'); s.textContent = t; s.className = 'tree-status ' + cls; },
  paintStats() { const s = this.stats; $('#stN').textContent = s.n; $('#stF').textContent = s.f; $('#stB').textContent = s.b; $('#stS').textContent = s.s; },
};
$('#treeGo').onclick = () => { Player.stop(); Tree.draw($('#treeQ').value, +$('#treeMax').value); };
$('#treeQ').addEventListener('keydown', e => { if (e.key === 'Enter') $('#treeGo').click(); });
$('#treePlay').onclick = () => {
  if (!Tree.nodes) return;
  if (Tree.k >= Tree.order.length) { Tree.draw($('#treeQ').value, +$('#treeMax').value); return; }
  Tree.playing = !Tree.playing; $('#treePlay').textContent = Tree.playing ? '⏸' : '▶';
};
$('#treeAll').onclick = () => Tree.showAll();

// ---------- retos -----------------------------------------------------
const key = (l, i) => `${l.id}:${i}`;
function checkQueryRetos(src) {
  L.retos.forEach((r, i) => {
    if (r.tipo !== 'query' || store.st.done[key(L, i)]) return;
    // usa: átomos que la consulta debe mencionar (evita aprobar con otra relación o el número tecleado)
    if (r.usa && !r.usa.every(a => new RegExp(`\\b${a}\\b`).test(src))) return;
    let ok = false;
    try { ok = PL.prolog.query('lab:lab_check(U, R)', { U: src, R: r.ref }).once().success === true; } catch (e) {}
    flush();
    if (ok) completeReto(i);
  });
}
function checkProgramRetos() {
  L.retos.forEach((r, i) => {
    if (r.tipo !== 'program' || store.st.done[key(L, i)]) return;
    let ok = false;
    try { ok = PL.prolog.query('lab:lab_chk(S)', { S: r.check }).once().success === true; } catch (e) {}
    flush();
    if (ok) completeReto(i);
  });
}
function completeReto(i) {
  store.st.done[key(L, i)] = true; store.save();
  out(`${A.bgreen}% ✓ Reto ${i + 1} superado${A.x}`);
  toast(`✓ Reto ${i + 1} superado`);
  renderLesson(); renderNav(); renderProgress();
}
let toastT;
function toast(msg) {
  const t = $('#toast'); t.textContent = msg; t.classList.add('show');
  clearTimeout(toastT); toastT = setTimeout(() => t.classList.remove('show'), 2200);
}
const hintLevel = {};

function renderLesson() {
  const done = L.retos.map((_, i) => !!store.st.done[key(L, i)]);
  const all = done.every(Boolean);
  const idx = LS.indexOf(L), nx = LS[idx + 1];
  $('#lesson').innerHTML = `
    <span class="lvl">Nivel ${L.nivel} · Lección ${L.id}</span>
    <h1>${L.titulo}</h1><p class="tema">${L.tema}</p>
    <p class="src">📖 ${L.fuente}</p>
    <div class="teoria">${L.teoria}</div>
    <h2>Retos · ${done.filter(Boolean).length}/${L.retos.length}</h2>
    ${L.retos.map((r, i) => {
      const h = hintLevel[key(L, i)] || 0;
      return `<div class="reto ${done[i] ? 'done' : ''}">
        <div class="reto-top"><span class="badge ${r.tipo}">${r.tipo === 'query' ? 'consulta' : 'programa'}</span>
          <b>Reto ${i + 1}</b><span class="estado">${done[i] ? '✓' : '○'}</span></div>
        <p>${r.enunciado}</p>
        ${h ? `<div class="hint">${r.pistas.slice(0, h).map((p, j) => j === r.pistas.length - 1 ? `<b>Solución:</b><pre>${esc(p)}</pre>` : `💡 ${esc(p)}`).join('<br>')}</div>` : ''}
        ${done[i] ? '' : `<div class="reto-actions">
          ${h < r.pistas.length - 1 ? `<button class="btn" data-hint="${i}">💡 Pista</button>` : ''}
          ${h < r.pistas.length ? `<button class="btn ghost" data-sol="${i}">Ver solución</button>` : `<button class="btn" data-use="${i}">${r.tipo === 'query' ? 'Escribir en terminal' : 'Agregar al editor'}</button>`}
        </div>`}
      </div>`;
    }).join('')}
    <div class="complete-banner ${all ? 'show' : ''}">🎉 Lección completada</div>
    <div class="next ${nx ? 'show' : ''}"><button class="btn ${all ? 'primary' : ''}" data-go="${nx ? nx.id : ''}">Siguiente: ${nx ? nx.titulo + ' — ' + nx.tema : ''} →</button></div>`;
}
$('#lesson').addEventListener('click', e => {
  const b = e.target.closest('button'); if (!b) return;
  if (b.dataset.hint) { const k = key(L, +b.dataset.hint); hintLevel[k] = (hintLevel[k] || 0) + 1; renderLesson(); }
  if (b.dataset.sol) { const i = +b.dataset.sol; hintLevel[key(L, i)] = L.retos[i].pistas.length; renderLesson(); }
  if (b.dataset.use) useSolution(+b.dataset.use);
  if (b.dataset.go) selectLesson(b.dataset.go);
});
async function useSolution(i) {
  const r = L.retos[i], sol = r.pistas[r.pistas.length - 1];
  if (r.tipo === 'program') {
    showView('editor');
    if (!srcEl.value.includes(sol)) {  // no duplicar si se pulsa dos veces
      srcEl.value = srcEl.value.replace(/\s*$/, '\n\n') + sol + '\n';
      srcEl.dispatchEvent(new Event('input'));
    }
    srcEl.scrollTop = srcEl.scrollHeight; srcEl.focus();
  } else {
    if (consultando) return;
    consultando = true;
    try {
      Player.stop();
      if (T.mode === 'more') moreKey('.');
      await Player.idle();
      T.buf = ''; T.pos = 0; redraw();
      Player.driving = true; await Player.type(sol, Player.token, 60); Player.driving = false;
      term.focus();
    } finally { consultando = false; }
  }
}

// ---------- navegación ------------------------------------------------
const lessonDone = l => l.retos.every((_, i) => store.st.done[key(l, i)]);
const lessonCount = l => l.retos.filter((_, i) => store.st.done[key(l, i)]).length;
function renderNav() {
  let h = '', lvl = 0;
  for (const l of LS) {
    if (l.nivel !== lvl) { lvl = l.nivel; h += `<div class="nav-group">Nivel ${lvl} · ${l.titulo}</div>`; }
    h += `<button class="nav-item ${l === L ? 'active' : ''} ${lessonDone(l) ? 'complete' : ''}" data-id="${l.id}">
      <span class="num">${lessonDone(l) ? '✓' : l.id}</span><span class="t">${l.tema}${l.local ? ' <span class="local-tag">LOCAL</span>' : ''}<small>${l.fuente.split(',')[0]}</small></span>
      <span class="cnt">${lessonCount(l)}/${l.retos.length}</span></button>`;
  }
  if (FUTURO.length) h += `<div class="nav-group">Próximamente</div>`;
  for (const [n, t, s, loc] of FUTURO)
    h += `<div class="nav-item soon"><span class="num">${n}</span><span class="t">${t}${loc ? ' <span class="local-tag">LOCAL</span>' : ''}<small>${s || '&nbsp;'}</small></span></div>`;
  $('#nav').innerHTML = h;
  $('#lessonSelect').innerHTML = LS.map(l => `<option value="${l.id}" ${l === L ? 'selected' : ''}>${l.id} · ${l.titulo} — ${l.tema} (${lessonCount(l)}/${l.retos.length})</option>`).join('');
}
$('#nav').addEventListener('click', e => { const b = e.target.closest('[data-id]'); if (b) selectLesson(b.dataset.id); });
$('#lessonSelect').onchange = e => selectLesson(e.target.value);
function renderProgress() {
  const tot = LS.reduce((a, l) => a + l.retos.length, 0), d = LS.reduce((a, l) => a + lessonCount(l), 0);
  $('#progTxt').textContent = `${d}/${tot} retos`; $('#progBar').style.width = (100 * d / tot) + '%';
}

function selectLesson(id) {
  const nl = LS.find(l => l.id === id) || LS[0];
  Player.stop(); Tree.gen++;
  if (T.moreRes) moreKey('.');
  if (L && PL) { try { PL.prolog.query('lab:lab_unload(B)', { B: L.archivo }).once(); } catch (e) {} }
  L = nl; Player.i = 0; Player.ui();
  store.st.last = L.id; store.save();
  srcEl.value = store.st.drafts[L.id] ?? L.programa; highlight();
  $('#fileName').textContent = L.archivo + '.pl';
  $('#termTitle').textContent = `swipl — ${L.archivo}.pl`;
  $('#crumb').innerHTML = `Nivel ${L.nivel} · <b>${L.titulo}</b> — ${L.tema}`;
  $('#treeQ').value = (L.demo.find(s => s.tree) || {}).tree || '';
  $('#treeWrap').querySelector('svg')?.remove(); $('#treeEmpty').style.display = '';
  Tree.nodes = null; Tree.status('Cada nodo es la lista de metas pendientes · □ éxito · ✗ falla · ↩ retroceso');
  Tree.stats = { n: 0, f: 0, b: 0, s: 0 }; Tree.paintStats();
  showView('editor');
  renderLesson(); renderNav(); renderProgress();
  $('#lesson').scrollTop = 0;
  if (PL) { resetTerminal(); term.focus(); }
}

// ---------- arranque --------------------------------------------------
async function boot() {
  selectLesson(store.st.last);
  term.write(A.dim + 'Cargando SWI-Prolog…' + A.x);
  try {
    PL = await SWIPL({
      arguments: ['-q'],
      locateFile: f => CDN + f,
      print: t => out(t),
      printErr: t => {
        t = t.replace(/\[Thread \w+\] /, '').replace(/\/\/?(\w+\.pl)/g, '$1');
        out((/^ERROR/.test(t) ? A.red : /^Warning/.test(t) ? A.yellow : '') + t + A.x);
      },
      setStatus: s => { if (s) $('#loadMsg').textContent = s.replace('Downloading data...', 'Descargando…'); },
    });
    PL.FS.writeFile('/lab.pl', window.LAB_PL);
    PL.prolog.query("consult('/lab.pl')").once();
    const v = PL.prolog.query('current_prolog_flag(version, V)').once().V;
    PL.version = `${Math.floor(v / 10000)}.${Math.floor(v / 100) % 100}.${v % 100}`;
    $('#statusTxt').textContent = `SWI-Prolog ${PL.version} · WASM`;
    $('#status').classList.add('ready');
    resetTerminal();
    $('#loading').classList.add('gone');
    term.focus();
  } catch (e) {
    $('#loadMsg').textContent = 'Error al cargar SWI-Prolog: ' + (e.message || e) + ' — revisa tu conexión.';
    $('.spinner').style.display = 'none';
  }
}
boot();
})();
