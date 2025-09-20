const express = require("express");
const path = require("path");
const fs = require("fs");

const app = express();
const PORT = 3000;

// Pasta para publicar arquivos
const PUBLIC_FOLDER = path.join(__dirname, "public");
if (!fs.existsSync(PUBLIC_FOLDER)) fs.mkdirSync(PUBLIC_FOLDER);

// Servir arquivos estáticos
app.use(express.static(PUBLIC_FOLDER));

// Rota principal
app.get("/", (req, res) => {
  const indexPath = path.join(PUBLIC_FOLDER, "index.html");
  if (fs.existsSync(indexPath)) {
    res.sendFile(indexPath);
  } else {
    res.send("<h2>Nenhum arquivo index.html encontrado na pasta public!</h2>");
  }
});

app.listen(PORT, () => {
  console.log(`Servidor rodando em http://localhost:${PORT}`);
});
