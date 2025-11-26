const AWS = require('aws-sdk');
const db = new AWS.DynamoDB.DocumentClient();
const TABLE = process.env.TABLE;

exports.handler = async (event) => {
  if (event.httpMethod === 'OPTIONS') return { statusCode: 204, headers: corsHeaders() };
  let body = {};
  try {
    body = JSON.parse(event.body || '{}');
  } catch(e) {
    return { statusCode: 400, body: JSON.stringify({ error: 'invalid json' }), headers: corsHeaders() };
  }
  const url = body.url;
  if (!url) return { statusCode: 400, body: JSON.stringify({ error: 'url required' }), headers: corsHeaders() };
  const codigo = Math.random().toString(36).substring(2,8);
  await db.put({ TableName: TABLE, Item: { code: codigo, url, createdAt: Date.now() } }).promise();
  return { statusCode: 200, body: JSON.stringify({ codigo }), headers: corsHeaders() };
};

function corsHeaders(){ return { 'Access-Control-Allow-Origin':'*','Access-Control-Allow-Methods':'GET,POST,OPTIONS','Access-Control-Allow-Headers':'Content-Type' }; }
