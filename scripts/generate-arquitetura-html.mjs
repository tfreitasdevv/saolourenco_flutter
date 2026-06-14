#!/usr/bin/env node

import fs from "node:fs";
import path from "node:path";

const repoRoot = path.resolve(
  path.dirname(new URL(import.meta.url).pathname),
  "..",
);
const arquiteturaDir = path.join(repoRoot, "docs", "arquitetura");
const outputFile = path.join(arquiteturaDir, "documentacao-arquitetural.html");

const sections = [
  {
    id: "indice",
    title: "Indice Arquitetural",
    shortTitle: "Indice",
    source: "INDICE.md",
    requiredForCoverage: false,
  },
  {
    id: "visao-contexto",
    title: "Visao de Contexto",
    shortTitle: "Contexto",
    source: "01-VISAO-CONTEXTO.md",
    requiredForCoverage: true,
  },
  {
    id: "modulos-componentes",
    title: "Modulos e Componentes",
    shortTitle: "Modulos",
    source: "02-MODULOS-COMPONENTES.md",
    requiredForCoverage: true,
  },
  {
    id: "integracoes-dados",
    title: "Integracoes e Dados",
    shortTitle: "Integracoes",
    source: "03-INTEGRAÇÕES-DADOS.md",
    requiredForCoverage: true,
  },
  {
    id: "decisoes-arquiteturais",
    title: "Decisoes Arquiteturais",
    shortTitle: "Decisoes",
    source: "04-DECISOES-ARQUITETURAIS.md",
    requiredForCoverage: true,
  },
  {
    id: "anexo-graphify",
    title: "Anexo Graphify Curadoria",
    shortTitle: "Curadoria",
    source: "ANEXO-GRAPHIFY-CURADORIA.md",
    requiredForCoverage: true,
  },
  {
    id: "cobertura-minima",
    title: "Criterios de Cobertura Minima",
    shortTitle: "Cobertura",
    source: "COBERTURA-MINIMA.md",
    requiredForCoverage: false,
  },
];

function readSectionMarkdown(fileName) {
  const filePath = path.join(arquiteturaDir, fileName);
  if (!fs.existsSync(filePath)) {
    throw new Error(`Arquivo de arquitetura nao encontrado: ${fileName}`);
  }
  return fs.readFileSync(filePath, "utf8");
}

function escapeHtml(text) {
  return text
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#39;");
}

function applyInlineMarkdown(text) {
  let html = escapeHtml(text);
  html = html.replace(/`([^`]+)`/g, "<code>$1</code>");
  html = html.replace(/\*\*([^*]+)\*\*/g, "<strong>$1</strong>");
  html = html.replace(/\*([^*]+)\*/g, "<em>$1</em>");
  html = html.replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2">$1</a>');
  return html;
}

function parseTable(lines, startIndex) {
  const headerLine = lines[startIndex];
  const separatorLine = lines[startIndex + 1] || "";

  const isSeparator = /^\|?\s*:?-{3,}:?\s*(\|\s*:?-{3,}:?\s*)+\|?$/.test(
    separatorLine.trim(),
  );
  if (!isSeparator) {
    return null;
  }

  const rows = [];
  let i = startIndex;
  while (i < lines.length && lines[i].includes("|") && lines[i].trim() !== "") {
    rows.push(lines[i]);
    i += 1;
  }

  const toCells = (line) =>
    line
      .trim()
      .replace(/^\|/, "")
      .replace(/\|$/, "")
      .split("|")
      .map((cell) => cell.trim());

  const headerCells = toCells(headerLine);
  const bodyRows = rows.slice(2).map(toCells);

  const thead = `<thead><tr>${headerCells.map((cell) => `<th>${applyInlineMarkdown(cell)}</th>`).join("")}</tr></thead>`;
  const tbody = `<tbody>${bodyRows
    .map(
      (row) =>
        `<tr>${row.map((cell) => `<td>${applyInlineMarkdown(cell)}</td>`).join("")}</tr>`,
    )
    .join("")}</tbody>`;

  return {
    html: `<table>${thead}${tbody}</table>`,
    nextIndex: i,
  };
}

function markdownToHtml(markdown) {
  const lines = markdown.replace(/\r\n/g, "\n").split("\n");
  const out = [];
  let i = 0;
  let inCodeBlock = false;
  let codeLang = "";
  let inUnorderedList = false;
  let inOrderedList = false;

  const closeLists = () => {
    if (inUnorderedList) {
      out.push("</ul>");
      inUnorderedList = false;
    }
    if (inOrderedList) {
      out.push("</ol>");
      inOrderedList = false;
    }
  };

  while (i < lines.length) {
    const line = lines[i];
    const trimmed = line.trim();

    if (/^```/.test(trimmed)) {
      if (!inCodeBlock) {
        closeLists();
        codeLang = trimmed.slice(3).trim();
        out.push(
          `<pre><code${codeLang ? ` class="language-${escapeHtml(codeLang)}"` : ""}>`,
        );
        inCodeBlock = true;
      } else {
        out.push("</code></pre>");
        inCodeBlock = false;
        codeLang = "";
      }
      i += 1;
      continue;
    }

    if (inCodeBlock) {
      out.push(`${escapeHtml(line)}\n`);
      i += 1;
      continue;
    }

    if (trimmed === "") {
      closeLists();
      i += 1;
      continue;
    }

    const table = parseTable(lines, i);
    if (table) {
      closeLists();
      out.push(table.html);
      i = table.nextIndex;
      continue;
    }

    const headingMatch = /^(#{1,6})\s+(.+)$/.exec(trimmed);
    if (headingMatch) {
      closeLists();
      const level = headingMatch[1].length;
      out.push(
        `<h${level}>${applyInlineMarkdown(headingMatch[2].trim())}</h${level}>`,
      );
      i += 1;
      continue;
    }

    if (/^---+$/.test(trimmed)) {
      closeLists();
      out.push("<hr>");
      i += 1;
      continue;
    }

    const unorderedMatch = /^[-*+]\s+(.+)$/.exec(trimmed);
    if (unorderedMatch) {
      if (inOrderedList) {
        out.push("</ol>");
        inOrderedList = false;
      }
      if (!inUnorderedList) {
        out.push("<ul>");
        inUnorderedList = true;
      }
      out.push(`<li>${applyInlineMarkdown(unorderedMatch[1])}</li>`);
      i += 1;
      continue;
    }

    const orderedMatch = /^\d+\.\s+(.+)$/.exec(trimmed);
    if (orderedMatch) {
      if (inUnorderedList) {
        out.push("</ul>");
        inUnorderedList = false;
      }
      if (!inOrderedList) {
        out.push("<ol>");
        inOrderedList = true;
      }
      out.push(`<li>${applyInlineMarkdown(orderedMatch[1])}</li>`);
      i += 1;
      continue;
    }

    const quoteMatch = /^>\s?(.*)$/.exec(trimmed);
    if (quoteMatch) {
      closeLists();
      out.push(
        `<blockquote>${applyInlineMarkdown(quoteMatch[1])}</blockquote>`,
      );
      i += 1;
      continue;
    }

    closeLists();
    const paragraphLines = [trimmed];
    i += 1;
    while (i < lines.length && lines[i].trim() !== "") {
      const lookahead = lines[i].trim();
      if (/^(#{1,6})\s+/.test(lookahead)) {
        break;
      }
      if (/^```/.test(lookahead)) {
        break;
      }
      if (/^[-*+]\s+/.test(lookahead) || /^\d+\.\s+/.test(lookahead)) {
        break;
      }
      if (
        lookahead.includes("|") &&
        /^\|?\s*:?-{3,}:?\s*(\|\s*:?-{3,}:?\s*)+\|?$/.test(
          (lines[i + 1] || "").trim(),
        )
      ) {
        break;
      }
      paragraphLines.push(lookahead);
      i += 1;
    }
    out.push(`<p>${applyInlineMarkdown(paragraphLines.join(" "))}</p>`);
  }

  closeLists();
  return out.join("\n");
}

function buildCoverageChecklist(existingSources) {
  const required = sections.filter((section) => section.requiredForCoverage);
  const items = required.map((section) => {
    const ok = existingSources.has(section.source);
    return `<li>${ok ? "✓" : "✗"} ${escapeHtml(section.title)} <span class="muted">(${escapeHtml(section.source)})</span></li>`;
  });

  const allOk = required.every((section) =>
    existingSources.has(section.source),
  );

  return {
    allOk,
    html: `<ul class="coverage-list">${items.join("")}</ul>`,
  };
}

function generate() {
  const renderedSections = [];
  const existingSources = new Set();

  for (const section of sections) {
    const markdown = readSectionMarkdown(section.source);
    existingSources.add(section.source);
    const contentHtml = markdownToHtml(markdown);

    renderedSections.push(`
      <section id="${section.id}" class="doc-section">
        <header class="section-header">
          <h2>${escapeHtml(section.title)}</h2>
          <p class="source-link">
            Fonte normativa: <a href="./${encodeURI(section.source)}">${escapeHtml(section.source)}</a>
          </p>
        </header>
        <article class="markdown-content">
          ${contentHtml}
        </article>
      </section>
    `);
  }

  const coverage = buildCoverageChecklist(existingSources);
  const now = new Date();
  const generatedAt = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, "0")}-${String(now.getDate()).padStart(2, "0")} ${String(now.getHours()).padStart(2, "0")}:${String(now.getMinutes()).padStart(2, "0")}`;

  const html = `<!DOCTYPE html>
<html lang="pt-BR">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Documentacao Arquitetural - Paroquia Sao Lourenco</title>
    <style>
      :root {
        --paper: #f7f4ed;
        --ink: #1f1f1f;
        --ink-soft: #4f4f4f;
        --brand: #8d4a2f;
        --brand-soft: #c57d58;
        --line: #d9cfbf;
        --panel: #fffdf8;
      }

      * { box-sizing: border-box; }

      body {
        margin: 0;
        color: var(--ink);
        font-family: "Source Serif 4", Georgia, "Times New Roman", serif;
        background:
          radial-gradient(circle at 10% -10%, #e9d8b4 0, transparent 40%),
          radial-gradient(circle at 100% 0%, #f5e8d6 0, transparent 35%),
          var(--paper);
        line-height: 1.6;
      }

      .layout {
        display: grid;
        grid-template-columns: 300px 1fr;
        min-height: 100vh;
      }

      .sidebar {
        position: sticky;
        top: 0;
        align-self: start;
        height: 100vh;
        overflow: auto;
        padding: 28px 20px;
        border-right: 1px solid var(--line);
        background: linear-gradient(170deg, rgba(255, 247, 232, 0.96), rgba(255, 253, 248, 0.88));
      }

      .sidebar h1 {
        margin-top: 0;
        margin-bottom: 10px;
        font-size: 1.4rem;
        line-height: 1.25;
      }

      .meta,
      .instruction {
        color: var(--ink-soft);
        font-size: 0.92rem;
      }

      .instruction {
        margin-top: 16px;
      }

      .quick-links,
      .source-map,
      .coverage-list {
        list-style: none;
        padding-left: 0;
      }

      .quick-links li,
      .source-map li,
      .coverage-list li {
        margin-bottom: 8px;
      }

      a {
        color: var(--brand);
        text-decoration: none;
      }

      a:hover,
      a:focus {
        text-decoration: underline;
      }

      .main {
        padding: 26px;
      }

      .summary-card {
        background: var(--panel);
        border: 1px solid var(--line);
        border-radius: 14px;
        padding: 20px;
        margin-bottom: 22px;
      }

      .badge {
        display: inline-block;
        padding: 4px 10px;
        border-radius: 999px;
        font-size: 0.8rem;
        border: 1px solid var(--line);
        background: #fff7ea;
      }

      .doc-section {
        background: var(--panel);
        border: 1px solid var(--line);
        border-radius: 14px;
        padding: 24px;
        margin-bottom: 20px;
      }

      .section-header {
        border-bottom: 1px dashed var(--line);
        margin-bottom: 18px;
      }

      .section-header h2 {
        margin-top: 0;
        margin-bottom: 8px;
      }

      .source-link {
        margin-top: 0;
        color: var(--ink-soft);
      }

      .markdown-content h1,
      .markdown-content h2,
      .markdown-content h3,
      .markdown-content h4 {
        margin-top: 1.3em;
      }

      .markdown-content table {
        width: 100%;
        border-collapse: collapse;
        margin: 12px 0;
      }

      .markdown-content th,
      .markdown-content td {
        border: 1px solid var(--line);
        padding: 8px;
        text-align: left;
        vertical-align: top;
      }

      .markdown-content pre {
        overflow-x: auto;
        background: #2d2a26;
        color: #fef8ee;
        padding: 12px;
        border-radius: 8px;
      }

      .markdown-content code {
        background: #f1ebdd;
        border-radius: 4px;
        padding: 0 4px;
      }

      .markdown-content pre code {
        background: none;
        padding: 0;
      }

      .muted {
        color: var(--ink-soft);
        font-size: 0.9rem;
      }

      .footer {
        margin-top: 24px;
        color: var(--ink-soft);
        font-size: 0.9rem;
      }

      @media (max-width: 980px) {
        .layout {
          grid-template-columns: 1fr;
        }

        .sidebar {
          position: static;
          height: auto;
          border-right: none;
          border-bottom: 1px solid var(--line);
        }

        .main {
          padding: 16px;
        }

        .doc-section {
          padding: 18px;
        }
      }
    </style>
  </head>
  <body>
    <div class="layout">
      <aside class="sidebar">
        <h1>Documentacao Arquitetural</h1>
        <p class="meta">Paroquia Sao Lourenco</p>
        <p class="meta">Gerado em: ${generatedAt}</p>
        <p class="instruction">Use os links abaixo para navegar por secoes e anexos sem depender de backend.</p>

        <h3>Navegacao Interna</h3>
        <ul class="quick-links">
          ${sections.map((section) => `<li><a href="#${section.id}">${escapeHtml(section.shortTitle)}</a></li>`).join("")}
        </ul>

        <h3>Mapa de Fontes</h3>
        <ul class="source-map">
          ${sections.map((section) => `<li><a href="./${encodeURI(section.source)}">${escapeHtml(section.source)}</a></li>`).join("")}
        </ul>
      </aside>

      <main class="main">
        <section class="summary-card" id="resumo-publicacao">
          <h2>Resumo da Publicacao HTML</h2>
          <p>Esta pagina consolida a documentacao em <code>docs/arquitetura</code> em um unico artefato HTML navegavel e offline-friendly.</p>
          <p><span class="badge">Fonte normativa preservada: Markdown</span> <span class="badge">Artefato derivado: HTML</span></p>
          <h3>Cobertura Minima Arquitetural</h3>
          ${coverage.html}
          <p class="muted">Status da cobertura: ${coverage.allOk ? "completa" : "incompleta"}.</p>
        </section>

        ${renderedSections.join("\n")}

        <p class="footer">Artefato gerado localmente por scripts/generate-arquitetura-html.mjs. Nenhuma chamada externa e necessaria para leitura.</p>
      </main>
    </div>
  </body>
</html>
`;

  fs.writeFileSync(outputFile, html, "utf8");
  console.log(`HTML gerado com sucesso em: ${outputFile}`);
}

try {
  generate();
} catch (error) {
  console.error("Falha ao gerar HTML arquitetural:", error.message);
  process.exit(1);
}
