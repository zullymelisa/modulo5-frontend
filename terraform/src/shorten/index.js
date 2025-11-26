const { DynamoDBClient } = require("@aws-sdk/client-dynamodb");
const { DynamoDBDocumentClient, PutCommand } = require("@aws-sdk/lib-dynamodb");

const client = new DynamoDBClient({});
const ddb = DynamoDBDocumentClient.from(client);
const TABLE = process.env.TABLE;

exports.handler = async (event) => {
  const method = event.httpMethod || (event.requestContext && event.requestContext.http && event.requestContext.http.method);
  if (method === 'OPTIONS') return { statusCode: 204, headers: corsHeaders() };
  let body = {};
  try { body = JSON.parse(event.body || '{}'); } catch(e) {
    return { statusCode: 400, body: JSON.stringify({ error: 'invalid json' }), headers: corsHeaders() };
  }
  const url = body.url;
  if (!url) return { statusCode: 400, body: JSON.stringify({ error: 'url required' }), headers: corsHeaders() };
  const codigo = Math.random().toString(36).substring(2,8);
  await ddb.send(new PutCommand({ TableName: TABLE, Item: { code: codigo, url, createdAt: Date.now() } }));
  return { statusCode: 200, body: JSON.stringify({ codigo }), headers: corsHeaders() };
};

function corsHeaders(){ return { 'Access-Control-Allow-Origin':'*','Access-Control-Allow-Methods':'GET,POST,OPTIONS','Access-Control-Allow-Headers':'Content-Type' }; }
