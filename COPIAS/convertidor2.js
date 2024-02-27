const puppeteer = require("puppeteer");
const axios = require("axios");
const fs = require("fs");

async function makeHtmlRequest() {
  const url = "http://190.128.136.58:8080/apex/scvchds/aq/aqHtml";

  const headers = {
    P_CLOTERECEP: "2024/286",
    P_FIL_NCODITPETAP: "-1",
    P_NCODITPORIG: "7",
    P_NCODIMERCA: "-1",
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
   // console.log(response.data);
    return response.data; // Devuelve solo el cuerpo de la respuesta en formato JSON
    // return response.data.items[1].html; // Devuelve solo el cuerpo de la respuesta en formato JSON
  } catch (error) {
    console.error("Error al hacer la solicitud HTTP:", error);
    throw error; // Propaga el error para manejarlo fuera de esta función si es necesario
  }
}

// return response;

// }

async function htmlToPdf(htmlContent, outputPath) {
    const browser = await puppeteer.launch();
    const page = await browser.newPage();
  
    // Configurar el encabezado de cada página
    const headerTemplate = `
      <div style="font-size: 12px; text-align: center; position: fixed; top: 0; width: 100%;">
        <span class="pageNumber"></span> / <span class="totalPages"></span>
      </div>
      <div style="font-size: 12px; text-align: center; position: fixed; top: 20px; width: 100%;">
        Hola Mundo
      </div>
    `;
  
    await page.setContent(htmlContent);
  
    // Configurar las opciones del PDF
    const pdfOptions = {
      path: outputPath,
      format: "A4",
      landscape: true, // Establecer la orientación horizontal
      printBackground: true,
      displayHeaderFooter: true, // Mostrar encabezado y pie de página
      headerTemplate, // Establecer el encabezado personalizado
      margin: {
        top: "80px", // Ajustar el margen superior para dejar espacio para el encabezado
      },
    };
  
    // Generar el PDF
    await page.pdf(pdfOptions);
  
    await browser.close();
  }
  
  

async function htmlToImage(htmlContent, outputPath) {
    const browser = await puppeteer.launch();
    const page = await browser.newPage();
    
    await page.setContent(htmlContent);
    const pageHeight = await page.evaluate(() => document.documentElement.offsetHeight);

    const maxPageHeight = 1200; // Altura máxima de la página en píxeles
    const numPages = Math.ceil(pageHeight / maxPageHeight);

    for (let i = 0; i < numPages; i++) {
        const sliceHeight = Math.min(maxPageHeight, pageHeight - i * maxPageHeight);
        await page.setViewport({ width: 1600, height: sliceHeight });

        const slicePath = `${outputPath.replace('.png', '')}_${i}.png`;
        await page.screenshot({ path: slicePath, clip: { x: 0, y: i * maxPageHeight, width: 1600, height: sliceHeight } });
    }

    await browser.close();
}

async function main() {

try {
    const htmlContent = await makeHtmlRequest();
    const outputPath = "output.pdf";
    const outputPathImage = "output.png";

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

    // Escribir el contenido HTML combinado en un archivo HTML
    const htmlFilePath = "output.html";
    fs.writeFileSync(htmlFilePath, combinedHtml);

    // Convertir el contenido HTML combinado a imagen
    await htmlToImage(combinedHtml, outputPathImage);

    // Convertir el contenido HTML combinado a PDF
    await htmlToPdf(combinedHtml, outputPath);
    console.log("PDF generado exitosamente");
  } catch (error) {
    console.error("Error al generar el PDF:", error);
  }
}

main();
