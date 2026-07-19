% =====================================================================
% Programa:    productos.pl
% Autor:       MC. René Solis R. — Docente, TecNM Campus Tijuana
% Curso:       Programación Lógica y Funcional (ISC-2006) — Ago–Dic 2026
% Actividad:   Proyecto Final P4 — Inventario SAT, capa 1
% Fecha:       2026-07-18
% Descripción: Base de hechos: productos y categorías fiscales
% IA:          Generado con Claude Code, verificado y modificado por el docente
% =====================================================================
:- module(productos, [producto_exento/1, producto_tasa_cero/1, categoria/2]).

%% producto_tasa_cero/1 — alimentos sin procesar, medicamentos (Art. 2-A LIVA)
producto_tasa_cero(leche).
producto_tasa_cero(tortilla).
producto_tasa_cero(huevo).
producto_tasa_cero(carne_res).
producto_tasa_cero(pollo).
producto_tasa_cero(verdura).
producto_tasa_cero(fruta).
producto_tasa_cero(medicamento).
producto_tasa_cero(insulina).

%% producto_exento/1 — exentos de IVA (Art. 9 LIVA)
producto_exento(libro).
producto_exento(revista_ciencia).
producto_exento(servicio_medico).
producto_exento(colegiatura).

%% categoria/2 — categoria(+Producto, -CatSAT)
%% Categorías simplificadas del catálogo SAT de productos y servicios
categoria(laptop,          electronico).
categoria(impresora,       electronico).
categoria(smartphone,      electronico).
categoria(escritorio,      mobiliario).
categoria(silla_oficina,   mobiliario).
categoria(papel_bond,      papeleria).
categoria(boligrafo,       papeleria).
categoria(libro,           educativo).
categoria(revista_ciencia, educativo).
categoria(medicamento,     farmacia).
categoria(leche,           alimento).
categoria(tortilla,        alimento).
