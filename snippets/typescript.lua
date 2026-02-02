local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local f = ls.function_node

--- TypeScript

ls.add_snippets("typescript", {

  -- Class
  s("cls", {
    t("export class "),
    i(1, "ClassName"),
    t(" {"),
    t({ "", "  constructor(" }),
    i(2),
    t(") {}"),
    t({ "", "}" }),
  }),

  -- Interface
  s("iface", {
    t("export interface "),
    i(1, "MyInterface"),
    t(" {"),
    t({ "", "  " }),
    i(2, "key: type"),
    t({ "", "}" }),
  }),

  s("type", {
    t("type "),
    i(1),
    t(" = {"),
    t({ "", "  " }),
    i(2, "key: type"),
    t({ "", "}" }),
  }),

  -- Async function
  s("afn", {
    t("export const "),
    i(1, "fn"),
    t(" = async ("),
    i(2),
    t("): Promise<"),
    i(3, "void"),
    t("> => {"),
    t({ "", "  " }),
    i(4),
    t({ "", "};" }),
  }),

  s("fnc", {
    t("export const "),
    i(1, "fn"),
    t(" = ("),
    i(2),
    t("): "),
    i(3, "void"),
    t(" => {"),
    t({ "", "  " }),
    i(4),
    t({ "", "};" }),
  }),

  s("fncc", {
    t("export function "),
    i(1, "fn"),
    t("("),
    i(2),
    t("): "),
    i(3, "void"),
    t(" {"),
    t({ "", "  " }),
    i(4),
    t({ "", "};" }),
  }),

  -- Try/Catch (trader-grade defensive coding)
  s("try", {
    t("try {"),
    t({ "", "  " }),
    i(1),
    t({ "", "} catch (err) {" }),
    t({ "", "  " }),
    i(2, "console.error(err)"),
    t({ "", "}" }),
  }),

  -- Loggerne
  s("log", {
    t("logger."),
    c(1, { t("info"), t("warn"), t("error"), t("debug") }),
    t("("),
    i(2),
    t(")"),
  }),

  s("dd", {
    t("console."),
    c(1, { t("info"), t("warn"), t("error"), t("debug") }),
    t("({"),
    i(2),
    t("})"),
  }),

  -- If the specified expression is false, the message is written to the console along with a stack trace
  s("cas", {
    t("// If the specified expression is false, the message is written to the console along with a stack trace"),
    t("console.assert"),
    t("("),
    i(1),
    t(","),
    i(2),
    t(")"),
  }),

  s("co", {
    t("const "),
    i(1, ""),
    t(" = "),
    i(2, ""),
  }),

  s("main", {
    t("async function main(): Promise<void> {"),
    t({ "", "  " }),
    i(1),
    t({ "", "}" }),
    t({ "", "void main()" }),
  }),

  s("ro-array", {
    t("const "),
    i(1, ""),
    t(": ReadonlyArray<"),
    i(2, "string"),
    t(">"),
    t(" = "),
    t("["),
    i(3, ""),
    t("]"),
  }),

  -- const point: readonly [number, number] = [0, 0];
  s("ro-tuple", {
    t("const "),
    i(1, ""),
    t(": readonly [number, number]"),
    t(" = "),
    t("["),
    i(3, ""),
    t("]"),
  }),

  s("map", {
    t("const "),
    i(1, ""),
    t("Map"),
    t(" = "),
    t("new Map<>"),
    i(3, ""),
    t("()"),
  }),
  s("todo", {
    t("// TODO "),
    i(1, ""),
  }),

  s("fixme", {
    t("// FIXME "),
    i(1, ""),
  }),

  s("hack", {
    t("// HACK "),
    i(1, ""),
  }),

  s("test", {
    t("it('will "),
    i(1, "description"),
    t("', () => {"),
    t({ "", "  " }),
    i(2),
    t({ "", "});" }),
  }),

  s("test-todo", {
    t("it.todo('will "),
    i(1, "description"),
    t("')"),
  }),

  s("describe", {
    t("describe('"),
    i(1, "suite"),
    t("', () => {"),
    t({ "", "  " }),
    i(2),
    t({ "", "});" }),
  }),

  s("expect", {
    t("expect("),
    i(1, "actual"),
    t(")."),
    c(2, {
      t("toBe("),
      i(3, "expected"),
      t(");"),
      t("toEqual("),
      i(3, "expected"),
      t(");"),
      t("toStrictEqual("),
      i(3, "expected"),
      t(");"),
      t("toMatchObject("),
      i(3, "{}"),
      t(");"),
    }),
  }),
})
