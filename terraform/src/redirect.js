const AWS = require('aws-sdk');
const db = new AWS.DynamoDB.DocumentClient();
const TABLE = process.env.TABLE;

exports.handler = async (event) => {
  if (event.httpMethod === 'OPTIONS') return { statusCode: 204, headers: corsHeaders() };
  const code = (event.pathParameters && event.pathParameters.code) || '';
  if (!code) return { statusCode: 400, body: JSON.stringify({ error: 'code missing' }), headers: corsHeaders() };
  const res = await db.get({ TableName: TABLE, Key: { code } }).promise();
  if (!res.Item) return { statusCode: 404, body: JSON.stringify({ error: 'not found' }), headers: corsHeaders() };
  return { statusCode: 200, body: JSON.stringify({ url: res.Item.url }), headers: corsHeaders() };
};

function corsHeaders(){ return { 'Access-Control-Allow-Origin':'*','Access-Control-Allow-Methods':'GET,POST,OPTIONS','Access-Control-Allow-Headers':'Content-Type' }; }
