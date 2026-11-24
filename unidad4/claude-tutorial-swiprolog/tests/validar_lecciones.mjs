// Valida todas las lecciones con swipl nativo:
//   node tests/validar_lecciones.mjs [id ...]
// Por lección: demo sin errores, árboles SLD, referencias con soluciones,
// soluciones (pistas) aprobadas, sin cruces entre retos, checks que fallan
// antes y pasan después, consultas sin warnings y `usa` presente en la solución.
import { mkdtempSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join, dirname } from 'node:path';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import { createRequire } from 'node:module';

const raiz = join(dirname(fileURLToPath(import.meta.url)), '..');
const require = createRequire(import.meta.url);
globalThis.window = {};
require(join(raiz, 'js/lab-core.js'));
require(join(raiz, 'js/lecciones.js'));

const tmp = mkdtempSync(join(tmpdir(), 'prologlab-'));
const lab = join(tmp, 'lab.pl');
writeFileSync(lab, window.LAB_PL);
const str = s => JSON.stringify(s).replace(/\\u([0-9a-f]{4})/gi, (_, h) => String.fromCharCode(parseInt(h, 16)));

const ids = process.argv.slice(2);
let malas = 0;
for (const L of window.LECCIONES.filter(l => !ids.length || ids.includes(l.id))) {
  const errs = [];
  L.retos.forEach((r, i) => {
    if (!r.pistas?.length) errs.push(`reto ${i + 1}: sin pistas`);
    const sol = r.pistas.at(-1);
    for (const a of r.usa || []) if (!new RegExp(`\\b${a}\\b`).test(sol)) errs.push(`reto ${i + 1}: la solución no menciona "${a}" (usa)`);
  });
  const casos = [
    ':- module(casos, []).', ':- dynamic demo/1, arbol/2, reto/4, usa/2.',
    `archivo(${str(join(tmp, L.archivo + '.pl'))}).`,
    `programa(${str(L.programa)}).`,
    ...L.demo.filter(s => s.q).map(s => `demo(${str(s.q)}).`),
    ...L.demo.filter(s => s.tree).map(s => `arbol(${str(s.tree)}, ${s.max || 1}).`),
    ...L.retos.map((r, i) => `usa(${i + 1}, ${str(r.usa || [])}).`),
    ...L.retos.map((r, i) => `reto(${i + 1}, ${r.tipo}, ${str(r.ref || r.check)}, ${str(r.pistas.at(-1))}).`),
  ].join('\n') + '\n';
  const f = join(tmp, `casos_${L.id}.pl`);
  writeFileSync(f, casos);
  const p = spawnSync('swipl', [join(raiz, 'tests/validar.pl'), '--', lab, f], { encoding: 'utf8', timeout: 120000 });
  const out = (p.stdout + p.stderr).trim();
  if (p.status !== 0 || errs.length) {
    malas++;
    console.log(`✗ ${L.id} ${L.tema}\n${[...errs.map(e => '  FALLA: ' + e), out].filter(Boolean).join('\n')}`);
  } else console.log(`✓ ${L.id} ${L.tema} (${L.retos.length} retos)`);
}
console.log(malas ? `\n${malas} lección(es) con fallas` : '\nTodas las lecciones pasan');
process.exit(malas ? 1 : 0);
