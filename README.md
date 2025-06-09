# mcp-server-llm-rules: Zed MCP Extension

This extension enables direct integration of the [llm-rules](https://www.npmjs.com/package/llm-rules) engine into the Zed editor via the MCP protocol.
It allows Zed to read rules from the same location as Cursor.

## How llm-rules Reads and Exposes Rules

The `llm-rules` library discovers Cursor rule files (typically in `.cursor/rules/*.mdc`) and exposes them to Zed and other MCP clients as dynamic tools. Each rule file must have YAML frontmatter at the top, which encodes rule metadata. This metadata is extracted and used to generate tool descriptions and annotations that guide the LLM on proper application of each rule.

The LLM applies the rules based on the context of the file being edited and the tool descriptions provided by the MCP. No user input is needed.

### Rule Frontmatter Properties

Each rule `.mdc` file must begin with YAML frontmatter, for example:
```markdown
---
description: Require all new APIs to include docstrings and Markdown docs.
globs: "src/**/*.py docs/**/*.md"
alwaysApply: true
---
Body of the rule here...
```

The main properties are:
- **description** (string, required): Describes the rule for the LLM. This line is used as the tool's description and is surfaced in UI and context, guiding when the rule should be triggered.
- **globs** (string, optional): File patterns indicating which files the rule applies to, e.g., `src/**/*.js`. Used to help the LLM match rules to files being edited.
- **alwaysApply** (boolean, optional): Marks rules that should always be enforced regardless of file pattern.

These three properties (`description`, `globs`, `alwaysApply`) are encoded into the tool's exposed metadata, so tools like Zed can filter, present, and automatically suggest or enforce rules as relevant.

### How the MCP Server Exposes Rules

- Each rule is surfaced as an MCP tool, with a name like `cursor_rule_<filename>`.
- The rule's YAML frontmatter controls the tool’s description and annotations.
- The LLM uses these fields to determine which rules to apply, when to offer suggestions, or enforce standards.
- Rules are automatically detected and enforced by the LLM—no manual user input is required for rule selection or activation.
- Rule content can be retrieved at runtime, so only relevant rules are loaded on-demand—keeping context lean while maintaining powerful automation in the editor.

This approach ensures the LLM receives just enough structured metadata about each rule to enforce or suggest best practices according to project and file context, leveraging rule "frontmatter" as the configuration mechanism.
