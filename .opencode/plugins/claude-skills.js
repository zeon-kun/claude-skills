/**
 * claude-skills — OpenCode plugin adapter
 *
 * Reads SKILL.md files from the skills/ directory and exposes each skill
 * as a named system-prompt provider. Zero npm dependencies — runs on
 * Node.js built-ins only.
 *
 * Entry point declared in package.json "main".
 */

"use strict";

const fs = require("fs");
const path = require("path");

// Resolve the repo root relative to this file's location (.opencode/plugins/)
const REPO_ROOT = path.resolve(__dirname, "..", "..");
const SKILLS_DIR = path.join(REPO_ROOT, "skills");

/**
 * Strip YAML frontmatter (--- ... ---) from a SKILL.md string.
 * Returns the body text only.
 */
function stripFrontmatter(content) {
  return content.replace(/^---\n[\s\S]*?\n---\n/, "").trim();
}

/**
 * Parse the `name:` field from YAML frontmatter.
 * Returns null if the field is not found.
 */
function parseName(content) {
  const match = content.match(/^---\n[\s\S]*?^name:\s*(.+)$/m);
  return match ? match[1].trim() : null;
}

/**
 * Parse the `description:` field from YAML frontmatter.
 * Returns an empty string if the field is not found.
 */
function parseDescription(content) {
  const match = content.match(/^---\n[\s\S]*?^description:\s*["']?(.+?)["']?$/m);
  return match ? match[1].trim() : "";
}

/**
 * Load all skills from the skills/ directory.
 * Returns an array of { name, description, prompt } objects.
 */
function loadSkills() {
  if (!fs.existsSync(SKILLS_DIR)) {
    return [];
  }

  const skillDirs = fs.readdirSync(SKILLS_DIR, { withFileTypes: true })
    .filter((entry) => entry.isDirectory())
    .map((entry) => entry.name);

  const skills = [];

  for (const dir of skillDirs) {
    const skillFile = path.join(SKILLS_DIR, dir, "SKILL.md");
    if (!fs.existsSync(skillFile)) {
      continue;
    }

    const raw = fs.readFileSync(skillFile, "utf8");
    const name = parseName(raw) || dir;
    const description = parseDescription(raw);
    const prompt = stripFrontmatter(raw);

    skills.push({ name, description, prompt });
  }

  return skills;
}

/**
 * OpenCode plugin export.
 *
 * OpenCode calls plugin.register(context) on load. Each skill is registered
 * as a named system-prompt provider that prepends the skill body to the
 * conversation context when invoked.
 */
module.exports = {
  name: "claude-skills",

  register(context) {
    const skills = loadSkills();

    for (const skill of skills) {
      context.registerSkill({
        name: skill.name,
        description: skill.description,
        systemPrompt: skill.prompt,
      });
    }
  },

  /**
   * Expose skill metadata for inspection / tooling.
   * Returns the loaded skill list without injecting anything.
   */
  listSkills() {
    return loadSkills().map(({ name, description }) => ({ name, description }));
  },
};
