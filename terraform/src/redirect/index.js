const { DynamoDBClient } = require("@aws-sdk/client-dynamodb");
const { DynamoDBDocumentClient, GetCommand } = require("@aws-sdk/lib-dynamodb");

const client = new DynamoDBClient({});
const ddb = DynamoDBDocumentClient.from(client);
const TABLE = process.env.TABLE;

exports.handler = async (event) => {
  const method = event.httpMethod || (event.requestContext && event.requestContext.http && event.requestContext.http.method);
  if (method === 'OPTIONS') return { statusCode: 204, headers: corsHeaders() };
  const code = (event.pathParameters && event.pathParameters.code) || (event.path && event.path.split('/').pop());
  if (!code) return { statusCode: 400, body: JSON.stringify({ error: 'code missing' }), headers: corsHeaders() };
  const res = await ddb.send(new GetCommand({ TableName: TABLE, Key: { code } }));
  if (!res.Item) return { statusCode: 404, body: JSON.stringify({ error: 'not found' }), headers: corsHeaders() };
  return { statusCode: 200, body: JSON.stringify({ url: res.Item.url }), headers: corsHeaders() };
};

function corsHeaders(){ return { 'Access-Control-Allow-Origin':'*','Access-Control-Allow-Methods':'GET,POST,OPTIONS','Access-Control-Allow-Headers':'Content-Type' }; }
