const path = require('path');

// 根據 APP_ENV 載入對應的 .env 檔案
const env = process.env.APP_ENV || 'dev';
require('dotenv').config({
  path: path.resolve(__dirname, `env/.env.${env}`)
});


// index.js
const express = require('express')
const app = express()
const PORT = process.env.PORT || 3000

app.get('/', (req, res) => {
  res.send(`Hello from ${process.env.APP_ENV} environment!`);
});

app.listen(PORT, () => {
  console.log(`App is running on port ${PORT}`)
})
