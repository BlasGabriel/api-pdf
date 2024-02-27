const puppeteer = require("puppeteer");
const axios = require("axios");
const fs = require("fs");
const imageBuffer = fs.readFileSync("./Logo.CHDS.png");


async function makeHtmlRequest() {
  const url = "http://190.128.136.58:8080/apex/scvchds/aq/aqHtml";

  const headers = {
    P_CLOTERECEP: "2024/286",
    P_FIL_NCODITPETAP: "-1",
    P_NCODITPORIG: "7",
    P_NCODIMERCA: "697",
    P_TPFORMSEARCH: "C",
  };
  //   const headers = {
  //     P_CLOTERECEP: "2571/2024",
  //     P_FIL_NCODITPETAP: "-1",
  //     P_NCODITPORIG: "13",
  //     P_NCODIMERCA: "-1",
  //     P_TPFORMSEARCH: "C",
  //   };

  try {
    const response = await axios.get(url, { headers });
    //    console.log(response.data);
    return response.data; // Devuelve solo el cuerpo de la respuesta en formato JSON
  } catch (error) {
    console.error("Error al hacer la solicitud HTTP:", error);
    throw error; // Propaga el error para manejarlo fuera de esta función si es necesario
  }
}


async function htmlToPdf(tableHtml, outputPath, data) {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();

  // Función para calcular el tamaño de fuente basado en el número de filas
  function calcularTamanoFuente(numFilas) {
    if (numFilas >= 1 && numFilas <= 10) {
      return "12px";
    } else if (numFilas >= 11 && numFilas <= 15) {
      return "11px";
    } else if (numFilas >= 16 && numFilas <= 18) {
      return "10px";
    } else {
      return "11px";
    }
  }

  // Función para agregar un contador a cada tabla
  function addCounterToTables(html) {
    let counter = 1;
    // Agregar contador a cada tabla encontrada
    return html.replace(/<table\s+class="seg_result"/g, () => {
      const newTable = `<table class="seg_result${counter}"`;
      counter++;
      return newTable;
    });
    // return html;
  }

  // Estructura HTML completa con la tabla recibida y contadores agregados
  let fullHtml = addCounterToTables(`
    <!DOCTYPE html>
    <html>
    <head>
      <style>
        .contenedor {
            /* width: 1100px; /* Tama?o fijo del contenedor */
         height: 650px; /* Altura fija del contenedor 
        background-color: red;*/
        width: 100%; 
        
        }
        table {
          border-spacing: 0;
          font-family: arial, sans-serif;
          border-collapse: collapse;
          width: 100%; /* Hace que la tabla ocupe todo el ancho del contenedor */
         /* Margin-left: 10px;*/
         /*   margin: 0 auto;*/
        
  
         
        }
        h1 {
          font-size: 12px;
        }
  
        td,
        th,
        tr {
          /* font-size: 18px; */
          border: 1px solid black;
          padding: 2px;
          color: black;
          width: 170px;
          /*font-size: 15px;
  font-size: calc(1em + 0.5vw);*/
        }
  
        .rep_header {
          text-align: left;
          color: black;
          font-weight: bold;
          font-size: 10px;
          /*    font-size: calc(1em + 0.5vw);    */
        }
        .t-Report-cell {
          text-align: center;
          /* font-size: 10px; */
          width: 70px;
        }
        .VER {
          background-color: #046704;
        }
        .t-Report-colHead {
          text-align: left;
          color: black;
          font-weight: bold;
          align-items: center;
          /* font-size: 10px; */
          /*   font-size: calc(1em + 0.5vw);*/
        }
  
        .t-Report-colHead2 {
          text-align: center;
          color: black;
          font-weight: bold;
          align-items: center;
          /* font-size: 10px; */
          /* font-size: calc(1em + 0.5vw);*/
        }
  
        #utima_linea:nth-child(even) {
          background-color: #d9d9d9; /* Color de fondo gris claro para filas pares */
        }
  
        #utima_linea:nth-child(odd) {
          background-color: white; /* Color de fondo blanco para filas impares */
        }
      </style>
    </head>
    <body>
      ${tableHtml}
    </body>
  </html>
    `);


  // !-------------------------------------------------------
  // Objeto que mapea las clases de las tablas con sus respectivos tamaños de fuente
  const tamanosFuentesPorClase = {};
  const tamanosFuentesPorClase2 = {};

  // Iterar sobre las clases de las tablas
  for (let i = 1; i <= 7; i++) {
    // Encuentra el número de filas para la tabla con la clase 'seg_resultN'
    const numFilasSegResultN = (
      fullHtml.match(
        new RegExp(`<table class="seg_result${i}">[\\s\\S]*?<\\/table>`, "g")
      ) || [""]
    ).reduce((acc, table) => {
      return acc + (table.match(/<tr/g) || []).length;
    }, 0);

    // Calcula el tamaño de fuente para la tabla 'seg_resultN'
    const tamanoFuenteSegResultN = calcularTamanoFuente(numFilasSegResultN);

    // Almacena el tamaño de fuente calculado en el objeto
    tamanosFuentesPorClase[`seg_result${i}`] = tamanoFuenteSegResultN;
    tamanosFuentesPorClase2[`seg_result${i}`] =
      tamanoFuenteSegResultN + numFilasSegResultN;

    // Aplica el tamaño de fuente al estilo de la tabla 'seg_resultN'
    fullHtml = fullHtml.replace(
      new RegExp(`class="seg_result${i}"`, "g"),
      `class="seg_result${i}" style="font-size: ${tamanoFuenteSegResultN}"`
    );

 

    // Construye la expresión regular con la variable claseTabla
    const matchPattern = new RegExp(
      `<table class="seg_result${i}"[^>]*>(.*?)<tr\\s+id="utima_linea"\\s+class="CoCo0">`,
      "gs"
    );
    const match = fullHtml.match(matchPattern);
    // console.log(match, i);

    // Verificar si se encontró una coincidencia
    if (match !== null && numFilasSegResultN > 16) {
      fullHtml = fullHtml.replace(
        /<tr\s+id="utima_linea"\s+class="CoCo11">/g,
        `</table> <div style="page-break-before: always;">${match[0]}`
      );
    } else {
      console.log(
        "No se encontró ninguna coincidencia para el patrón especificado."
      );
    }
  }

  console.log(
    "Tamaños de fuente para cada clase de tabla:",
    tamanosFuentesPorClase2
  );

  

  // Configurar el encabezado de cada página
  const headerTemplate = `
  <table style="width: 100%; border-collapse: collapse; font-size: 10px; border: 1px solid black; margin-left: 17px; margin-right: 17px;">
  <tr>
    <td rowspan="4" style="width: 15%; vertical-align: middle; text-align: center; border: 1px solid black;">
 
    <img src="data:image/png;base64,${imageBuffer.toString('base64')}" width="100%" height="auto">

    </td>
    <td rowspan="4" style="width: 65%; vertical-align: middle; text-align: center; font-size: 25px; border: 1px solid black;">Seguimiento  de Resultados</td>
    <td style="width: 10%; border: 1px solid black;"><strong> Código </strong> </td>
    <td style="width: 10%; border: 1px solid black;">CHDS-RE-134</td>
</tr>
    <td style="width: 10%; border: 1px solid black;"><strong>Revisión </strong> </td>
    <td style="width: 10%; border: 1px solid black;"> 01</td>
  </tr>
<tr>
    <td style="border: 1px solid black;"><strong>Vigencia </strong> </td>
    <td style="border: 1px solid black;">01/01/2024</td>
  </tr>
<tr>
  
    <td style="border: 1px solid black;"><strong>Página </strong></td>
    <td style="border: 1px solid black;"> <span class="pageNumber"></span> / <span class="totalPages"></span></td>
  </tr>
  <tr>
  <td colspan="4" style="border: 1px solid black;">
  <p style="white-space: nowrap; margin: 2; display: inline;">
    <strong>Productos:</strong>${ data.produto }</p>
    <p style="white-space: nowrap; margin: 2; display: inline;"><strong>Fecha de actualización de rango: </strong>${ data.data_parametro } </p>         
    <p style="white-space: nowrap; margin: 2; display: inline;"> <strong >Responsable:</strong>${data.usuar_parametro }</p>
  </br>
  <p style="white-space: nowrap; margin: 0; display: inline;  "><strong>Lote:</strong> ${ data.lote }</p>
  <p style="white-space: nowrap; margin: 0; display: inline;" margin-left: 100px;"><strong>Origen:</strong> ${ data.cdesctporig }</p>
</td>

</tr>
</table>

    `;
  // Generar el PDF
  const pdfOptions = {
    path: outputPath,
    format: "A4",
    landscape: true, // Establecer la orientación horizontal
    printBackground: true,
   displayHeaderFooter: true, // Mostrar encabezado y pie de página
   headerTemplate, // Establecer el encabezado personalizado
   footerTemplate: `
                    <div style="font-size: 10px; padding-top: 10px; width: 100%; margin-left: 17px; margin-right: 17px;">
                        <span style="float: left;  color: red;">DOCUMENTO CONFIDENCIAL</span>
                        <span style="float: right;">Ref.: CHDS-PRO-015</span>
                    </div>`,
    margin: {
    //  top: "100px", // Ajustar el margen superior para dejar espacio para el encabezado
       top: "145px", // Ajustar el margen superior para dejar espacio para el encabezado
    //   bottom: "50px", // Ajustar el margen inferior para dejar espacio para el pie de página
      left: "10px", // Ajustar el margen izquierdo
      right: "10px", // Ajustar el margen derecho
    },
  };

  await page.setContent(fullHtml);
  await page.pdf(pdfOptions);
   // Escribir el contenido HTML combinado en un archivo HTML
//    const htmlFilePath = "output.html";
//    fs.writeFileSync(htmlFilePath, fullHtml);
 
  await browser.close();
}

async function main() {
  try {
    const htmlContent = await makeHtmlRequest();
    const outputPath = "output.pdf";
    const data = {
      cdesctporig: htmlContent.items[0].cdesctporig,
      cdesctporig2: htmlContent.items[0].cdesctporig2,
      data_parametro: htmlContent.items[0].data_parametro,
      usuar_parametro: htmlContent.items[0].usuar_parametro,
      recibido_por: htmlContent.items[0].recibido_por,
      ddatarecep: htmlContent.items[0].ddatarecep,
      ddataanali: htmlContent.items[0].ddataanali,
      produto: htmlContent.items[0].produto,
      lote: htmlContent.items[0].lote,
    };
    console.log(data);
    

    // Crear una cadena para almacenar el contenido HTML combinado
    let combinedHtml = "";

    // Recorrer cada elemento en htmlContent.items
    htmlContent.items.forEach((item, index) => {
      // Agregar el contenido HTML del elemento actual a la cadena combinada
      combinedHtml += item.html;
      // Agregar un salto de página si no es el último elemento
      if (index !== htmlContent.items.length - 1) {
        combinedHtml += '<div style="page-break-before: always;"></div>';
      }
    });

 

    // Convertir el contenido HTML combinado a PDF
    await htmlToPdf(combinedHtml, outputPath, data);
    console.log("PDF generado exitosamente");
  } catch (error) {
    console.error("Error al generar el PDF:", error);
  }
}

main();
