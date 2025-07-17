#!/usr/bin/env node

import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
  ToolSchema,
} from "@modelcontextprotocol/sdk/types.js";
import { z } from "zod";
import { zodToJsonSchema } from "zod-to-json-schema";

// Schema definitions
const GetCurrentDateTimeArgsSchema = z.object({});

const GetFormattedDateTimeArgsSchema = z.object({
  format: z.string().optional().describe('Date format (default: yyyy.MM.dd HH:mm:ss)'),
  timezone: z.string().optional().describe('Timezone (default: Asia/Seoul)'),
});

const ToolInputSchema = ToolSchema.shape.inputSchema;

// Server setup
const server = new Server(
  {
    name: "datetime-mcp",
    version: "1.0.0",
  },
  {
    capabilities: {
      tools: {},
    },
  },
);

// Utility functions
/**
 * @param {Date} date
 * @param {string=} format
 * @returns {string}
 */
function formatDateTime(date, format) {
  format = format || "yyyy.MM.dd HH:mm:ss";
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  const hours = String(date.getHours()).padStart(2, '0');
  const minutes = String(date.getMinutes()).padStart(2, '0');
  const seconds = String(date.getSeconds()).padStart(2, '0');

  return format
    .replace('yyyy', String(year))
    .replace('MM', month)
    .replace('dd', day)
    .replace('HH', hours)
    .replace('mm', minutes)
    .replace('ss', seconds);
}

/**
 * @param {string=} timezone
 * @returns {Date}
 */
function getCurrentDateTime(timezone) {
  timezone = timezone || "Asia/Seoul";
  return new Date(new Date().toLocaleString("en-US", { timeZone: timezone }));
}

// Tool handlers
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: "get_current_datetime",
        description:
          "Get the current date and time in yyyy.MM.dd HH:mm:ss format (Asia/Seoul timezone).",
        inputSchema: zodToJsonSchema(GetCurrentDateTimeArgsSchema),
      },
      {
        name: "get_formatted_datetime",
        description:
          "Get the current date and time with custom format and timezone. " +
          "Supports format tokens: yyyy (year), MM (month), dd (day), HH (hour), mm (minute), ss (second).",
        inputSchema: zodToJsonSchema(GetFormattedDateTimeArgsSchema),
      },
    ],
  };
});

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  try {
    const { name, arguments: args } = request.params;

    switch (name) {
      case "get_current_datetime": {
        const parsed = GetCurrentDateTimeArgsSchema.safeParse(args);
        if (!parsed.success) {
          throw new Error(`Invalid arguments for get_current_datetime: ${parsed.error}`);
        }

        const now = getCurrentDateTime();
        const formatted = formatDateTime(now);

        return {
          content: [{
            type: "text",
            text: formatted
          }],
        };
      }

      case "get_formatted_datetime": {
        const parsed = GetFormattedDateTimeArgsSchema.safeParse(args);
        if (!parsed.success) {
          throw new Error(`Invalid arguments for get_formatted_datetime: ${parsed.error}`);
        }

        const format = parsed.data.format || "yyyy.MM.dd HH:mm:ss";
        const timezone = parsed.data.timezone || "Asia/Seoul";
        const now = getCurrentDateTime(timezone);
        const formatted = formatDateTime(now, format);

        return {
          content: [{
            type: "text",
            text: formatted
          }],
        };
      }

      default:
        throw new Error(`Unknown tool: ${name}`);
    }
  } catch (error) {
    console.error(`Error handling tool request: ${error.message}`);
    return {
      content: [{ type: "text", text: `Error: ${error.message}` }],
      isError: true,
    };
  }
});

// Start server
async function runServer() {
  try {
    console.error("DateTime MCP Server starting...");

    const transport = new StdioServerTransport();
    await server.connect(transport);
    console.error("DateTime MCP Server running on stdio");
  } catch (error) {
    console.error("Fatal error running server:", error);
    process.exit(1);
  }
}

runServer().catch((error) => {
  console.error("Fatal error running server:", error);
  process.exit(1);
});