function f_return_seg_resul_html2(P_CLOTERECEP in varchar2, P_NCODITPORIG  VARCHAR2,P_MINROWNUM    IN NUMBER,P_MAXROWNUM    IN NUMBER, P_TPFORMSEARCH VARCHAR2 , P_NCODITPETAP IN number default -1, P_NCODIMERCA  IN number default -1 ) return clob is
          v_return clob;
          -- Local variables here
          V_HEADER       CLOB;
          V_TABLE_BODY   CLOB;
          V_HTML         CLOB;
          V_TABLE_FOOTER clob;
          V_CONTADOR     NUMBER;
          CURSOR C_COUNT_REGISTRO_C IS
            SELECT COUNT(*)
              FROM (SELECT LAQRECEP.*, ROWNUM REGISTRO
                      FROM LAQRECEP, PERPERSO, LAQTPORIG
                     WHERE LAQRECEP.CSITURECEP = 'A'
                       AND LAQRECEP.NPESORECP = PERPERSO.NCODIPERSO
                       AND LAQRECEP.NCODITPORIG = LAQTPORIG.NCODITPORIG
                       AND LAQRECEP.NCODITPORIG = P_NCODITPORIG
                       AND ((P_NCODITPETAP = -1)
                                        OR
                          (LAQRECEP.NCODITPETAP = P_NCODITPETAP))
                       AND INSTR(UPPER(LAQRECEP.CLOTERECEP), UPPER(P_CLOTERECEP)) > 0 --|| C_COLUNAS.NCODIRECEP||
                       AND ((P_NCODIMERCA = -1 )
                                        OR 
                                        (LAQRECEP.NCODIRECEP IN 
                                               (SELECT LAQRECMER.NCODIRECEP 
                                                  FROM LAQRECMER 
                                                 WHERE LAQRECMER.NCODIMERCA = P_NCODIMERCA)))
                     ORDER BY LAQRECEP.DDATARECEP)
             WHERE REGISTRO >= P_MINROWNUM
               AND REGISTRO <= P_MAXROWNUM;
           CURSOR C_COUNT_REGISTRO_E IS
            SELECT COUNT(*)
              FROM (SELECT LAQRECEP.*, ROWNUM REGISTRO
                      FROM LAQRECEP, PERPERSO, LAQTPORIG
                     WHERE LAQRECEP.CSITURECEP = 'A'
                       AND LAQRECEP.NPESORECP = PERPERSO.NCODIPERSO
                       AND LAQRECEP.NCODITPORIG = LAQTPORIG.NCODITPORIG
                       AND LAQRECEP.NCODITPORIG = P_NCODITPORIG
                       AND ((P_NCODITPETAP = -1)
                                        OR
                          (LAQRECEP.NCODITPETAP = P_NCODITPETAP))
                      AND UPPER(LAQRECEP.CLOTERECEP) = UPPER(P_CLOTERECEP) --|| C_COLUNAS.NCODIRECEP||
                      AND ((P_NCODIMERCA = -1 )
                                        OR 
                                        (LAQRECEP.NCODIRECEP IN 
                                               (SELECT LAQRECMER.NCODIRECEP 
                                                  FROM LAQRECMER 
                                                 WHERE LAQRECMER.NCODIMERCA = P_NCODIMERCA)))
                     ORDER BY LAQRECEP.DDATARECEP)
             WHERE REGISTRO >= P_MINROWNUM
               AND REGISTRO <= P_MAXROWNUM;

          V_COUNT_REGISTRO NUMBER;
        begin
          -- Test statements here
        IF P_TPFORMSEARCH = 'C' THEN 
          OPEN C_COUNT_REGISTRO_C;
          FETCH C_COUNT_REGISTRO_C
            INTO V_COUNT_REGISTRO;
          CLOSE C_COUNT_REGISTRO_C;
        ELSIF P_TPFORMSEARCH = 'E' THEN 
            OPEN C_COUNT_REGISTRO_E;
          FETCH C_COUNT_REGISTRO_E
            INTO V_COUNT_REGISTRO;
          CLOSE C_COUNT_REGISTRO_E;
        END IF;

          IF V_COUNT_REGISTRO > 0 THEN
          
    V_HTML := q'~  
                                <!DOCTYPE html>

                             <html>
                              <head>
                              
                             <style>
                             #contenedor {
                             width: 1100px; /* Tama?o fijo del contenedor */
                              height: 700px; /* Altura fija del contenedor 
                         background-color: red;*/
        }
            table {
              border-spacing: 0;
              font-family: arial, sans-serif;
              border-collapse: collapse;
                          width: 100%; /* Hace que la tabla ocupe todo el ancho del contenedor */

                          font-size: calc(1em + 0.5vw); /*font-size: 10px; Tama?o de fuente relativo */

                 
            }
            h1{
           font-size: 16px;

            }

            td, th,tr {
              font-size: 18px;
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
            /*    font-size: calc(1em + 0.5vw);    */        }
            .t-Report-cell {
              text-align: center;
            font-size: 10px;
             width: 70px;


            }
            .VER
           {
              
                           background-color: #046704;


            }
            .t-Report-colHead {
              text-align: left;
              color: black;
              font-weight: bold;
              align-items: center;
 font-size: 10px;
             /*   font-size: calc(1em + 0.5vw);*/
            }
          

            .t-Report-colHead2 {
              text-align: center;
              color: black;
              font-weight: bold;
              align-items: center;
 font-size: 10px;
               /* font-size: calc(1em + 0.5vw);*/

            }
            



#utima_linea:nth-child(even) {
  background-color: #828282; /* Color de fondo gris claro para filas pares */
}

#utima_linea:nth-child(odd) {
  background-color: white; /* Color de fondo blanco para filas impares */
}



            
          </style>
                                 <script>
    // Obtener el número de filas en la tabla
    var numeroFilas = document.getElementById('contenedor').getElementsByTagName('tr').length;

    // Definir el tamaño de la fuente según el número de filas
    var tamanoFuente;

    if (numeroFilas >= 1 && numeroFilas <= 10) {
        tamanoFuente = '15px'; // o cualquier otra unidad de medida
    } else if (numeroFilas >= 11 && numeroFilas <= 13) {
        tamanoFuente = '11px';
    } else if (numeroFilas >= 14 && numeroFilas <= 16) {
        tamanoFuente = '10px';
    } else if (numeroFilas >= 17 && numeroFilas <= 18) {
        tamanoFuente = '8px';
    } else {
        tamanoFuente = '6px';
    }

    // Aplicar el tamaño de la fuente a todas las celdas de la tabla
    var celdas = document.querySelectorAll('#contenedor td, #contenedor th');
    celdas.forEach(function(celda) {
        celda.style.fontSize = tamanoFuente;
    });
</script>
                             </head>
                             <body class="container">
                             
    



                                <div id="contenedor">

                          ~';
     
            V_HEADER := V_HTML;
            V_HEADER := V_HEADER || '<table  class="seg_result">';
   IF P_TPFORMSEARCH = 'C' THEN
              FOR I IN 1 .. 7 LOOP
                V_HEADER := V_HEADER || ' <tr class="t-Report-cell">';
                IF I = 1 THEN
                  V_CONTADOR := 0;
                  FOR C_HEADERS IN /*(SELECT *
                                      FROM (SELECT PERPERSO.CNOMEPERSO,
                                                   ROWNUM REGISTRO
                                              FROM LAQRECEP, PERPERSO, LAQTPORIG
                                             WHERE LAQRECEP.CSITURECEP = 'A'
                                               AND LAQRECEP.NPESORECP =  PERPERSO.NCODIPERSO
                                               AND LAQRECEP.NCODITPORIG = P_NCODITPORIG
                                               AND LAQRECEP.NCODITPORIG = LAQTPORIG.NCODITPORIG
                                               AND ((P_NCODITPETAP = -1)
                                                     OR
                                                    (LAQRECEP.NCODITPETAP = P_NCODITPETAP))
                                                         
                                               AND INSTR(UPPER(LAQRECEP.CLOTERECEP), UPPER(P_CLOTERECEP)) > 0 --|| C_COLUNAS.NCODIRECEP||
                                               AND ((P_NCODIMERCA = -1 )
                                                     OR 
                                                    (LAQRECEP.NCODIRECEP IN 
                                                             (SELECT LAQRECMER.NCODIRECEP 
                                                                FROM LAQRECMER 
                                                               WHERE LAQRECMER.NCODIMERCA = P_NCODIMERCA)))
                                             ORDER BY LAQRECEP.DDATARECEP)
                                     WHERE REGISTRO >= P_MINROWNUM
                                       AND REGISTRO <= P_MAXROWNUM
                                       order by REGISTRO)*/
                                       (SELECT *
                                          FROM (SELECT DATOS.*, ROWNUM REGISTRO
                                                  FROM (SELECT PERPERSO.CNOMEPERSO
                                                          FROM LAQRECEP, PERPERSO, LAQTPORIG
                                                         WHERE LAQRECEP.CSITURECEP = 'A'
                                                           AND LAQRECEP.NPESORECP = PERPERSO.NCODIPERSO
                                                           AND LAQRECEP.NCODITPORIG = LAQTPORIG.NCODITPORIG
                                                           AND LAQRECEP.NCODITPORIG = P_NCODITPORIG
                                                           AND ((P_NCODITPETAP = -1) OR
                                                               (LAQRECEP.NCODITPETAP = P_NCODITPETAP))
                                                              
                                                           AND INSTR(UPPER(LAQRECEP.CLOTERECEP), UPPER(P_CLOTERECEP)) > 0 --|| C_COLUNAS.NCODIRECEP||
                                                           AND ((P_NCODIMERCA = -1) OR
                                                               (LAQRECEP.NCODIRECEP IN
                                                               (SELECT LAQRECMER.NCODIRECEP
                                                                    FROM LAQRECMER
                                                                   WHERE LAQRECMER.NCODIMERCA = P_NCODIMERCA)))
                                                         ORDER BY LAQRECEP.DDATARECEP)DATOS) 

                                         WHERE REGISTRO >= P_MINROWNUM
                                           AND REGISTRO <= P_MAXROWNUM
                                        /*order by REGISTRO*/)LOOP
                    IF V_CONTADOR = 0 THEN
                      V_HEADER := V_HEADER ||
                                  '<th colspan="2"   class="t-Report-colHead" > Solicitado Por:</th>';
                    
                    END IF;
                    V_HEADER   := V_HEADER ||
                                  '<th colspan="3"   class="t-Report-colHead2" >' ||
                                  C_HEADERS.CNOMEPERSO || '</th>';
                    V_CONTADOR := 1;
                  END LOOP;
                 V_CONTADOR := 5 -V_COUNT_REGISTRO;
                 
                 FOR RELLENO IN 1..V_CONTADOR LOOP
                     
                 V_HEADER := V_HEADER || ' <th colspan="3" class="t-Report-colHead2">-</th>';
                 
                 END LOOP;
                 
                
                ELSIF I = 2 THEN
                  V_CONTADOR := 0;
                  FOR C_HEADERS IN (SELECT *
                                      FROM (
                                            SELECT LAQRECEP.*, ROWNUM REGISTRO
                                              FROM (SELECT to_char(LAQRECEP.DDATARECEP,'DD-MM-YYYY')DDATARECEP
                                                      FROM LAQRECEP, PERPERSO, LAQTPORIG
                                                     WHERE LAQRECEP.CSITURECEP = 'A'
                                                       AND LAQRECEP.NPESORECP = PERPERSO.NCODIPERSO
                                                       AND LAQRECEP.NCODITPORIG = P_NCODITPORIG
                                                       AND LAQRECEP.NCODITPORIG = LAQTPORIG.NCODITPORIG
                                                       AND ((P_NCODITPETAP = -1)
                                                            OR
                                                            (LAQRECEP.NCODITPETAP = P_NCODITPETAP))
                                                       AND INSTR(UPPER(LAQRECEP.CLOTERECEP),  UPPER(P_CLOTERECEP)) > 0 --|| C_COLUNAS.NCODIRECEP||
                                                       AND ((P_NCODIMERCA = -1 )
                                                            OR 
                                                            (LAQRECEP.NCODIRECEP IN 
                                                                   (SELECT LAQRECMER.NCODIRECEP 
                                                                      FROM LAQRECMER 
                                                                     WHERE LAQRECMER.NCODIMERCA = P_NCODIMERCA)))
                                                     ORDER BY LAQRECEP.DDATARECEP)LAQRECEP
                                            )LAQRECEP
                                     WHERE REGISTRO >= P_MINROWNUM
                                       AND REGISTRO <= P_MAXROWNUM) 
                   LOOP
                    IF V_CONTADOR = 0 THEN
                    
                      V_HEADER := V_HEADER ||
                                  '<th colspan="2"  class="t-Report-colHead" > Fecha:</th>';
                    
                    END IF;
                    V_HEADER   := V_HEADER ||
                                  '<th colspan="3"  class="t-Report-colHead2" >' ||
                                  C_HEADERS.DDATARECEP || '</th>';
                    V_CONTADOR := 1;
                  END LOOP;
                    V_CONTADOR := 5 -V_COUNT_REGISTRO;
                 FOR RELLENO IN 1..V_CONTADOR LOOP
                     
                 V_HEADER := V_HEADER || ' <th colspan="3" class="t-Report-colHead2">-</th>';
                 
                 END LOOP;
                 
                ELSIF I = 3 THEN
                  V_CONTADOR := 0;
                
                  FOR C_HEADERS IN (SELECT *
                                      FROM (
                                            SELECT LAQRECEP.*, ROWNUM REGISTRO
                                              FROM (SELECT to_CHAR(LAQRECEP.DDATARECEP, 'HH24:MI') HORA
                                                      FROM LAQRECEP, PERPERSO, LAQTPORIG
                                                     WHERE LAQRECEP.CSITURECEP = 'A'
                                                     AND ((P_NCODITPETAP = -1)
                                                                        OR
                                                          (LAQRECEP.NCODITPETAP = P_NCODITPETAP))
                                                         
                                                       AND LAQRECEP.NPESORECP = PERPERSO.NCODIPERSO
                                                       AND LAQRECEP.NCODITPORIG = P_NCODITPORIG
                                                       AND LAQRECEP.NCODITPORIG = LAQTPORIG.NCODITPORIG
                                                       AND INSTR(UPPER(LAQRECEP.CLOTERECEP), UPPER(P_CLOTERECEP)) > 0 --|| C_COLUNAS.NCODIRECEP||
                                                       AND ((P_NCODIMERCA = -1 )
                                                                        OR 
                                                                        (LAQRECEP.NCODIRECEP IN 
                                                                               (SELECT LAQRECMER.NCODIRECEP 
                                                                                  FROM LAQRECMER 
                                                                                 WHERE LAQRECMER.NCODIMERCA = P_NCODIMERCA)))
                                                     ORDER BY LAQRECEP.DDATARECEP)LAQRECEP
                                           )LAQRECEP
                                     WHERE REGISTRO >= P_MINROWNUM
                                       AND REGISTRO <= P_MAXROWNUM) 
                  LOOP
                    IF V_CONTADOR = 0 THEN
                    
                      V_HEADER := V_HEADER ||
                                  '<th colspan="2"  class="t-Report-colHead" > Hora:</th>';
                    
                    END IF;
                    V_CONTADOR := 1;
                    V_HEADER   := V_HEADER ||
                                  '<th colspan="3"  class="t-Report-colHead2" >' ||
                                  C_HEADERS.HORA || '</th>';
                  
                  END LOOP;
                     V_CONTADOR := 5 -V_COUNT_REGISTRO;
                  FOR RELLENO IN 1..V_CONTADOR LOOP
                     
                 V_HEADER := V_HEADER || ' <th colspan="3" class="t-Report-colHead2">-</th>';
                 
                 END LOOP;
                ELSIF I = 4 THEN
                  V_CONTADOR := 0;
                
                  FOR C_HEADERS IN (SELECT LAQRECEP.*
                                      FROM (
                                            SELECT LAQRECEP.*, ROWNUM REGISTRO
                                              FROM (SELECT LAQRECEP.DDATARECEP,SYSUSUAR.CNOMEUSUAR 
                                                      FROM LAQRECEP, PERPERSO, LAQTPORIG ,SYSUSUAR
                                                     WHERE LAQRECEP.CSITURECEP = 'A'
                                                       AND LAQRECEP.NCODIUSUAR = SYSUSUAR.NCODIUSUAR
                                                       AND LAQRECEP.NPESORECP = PERPERSO.NCODIPERSO
                                                       AND LAQRECEP.NCODITPORIG = P_NCODITPORIG
                                                       AND LAQRECEP.NCODITPORIG = LAQTPORIG.NCODITPORIG
                                                       AND ((P_NCODITPETAP = -1)
                                                                    OR
                                                            (LAQRECEP.NCODITPETAP = P_NCODITPETAP))
                                                   
                                                       AND INSTR(UPPER(LAQRECEP.CLOTERECEP), UPPER(P_CLOTERECEP)) > 0 --|| C_COLUNAS.NCODIRECEP||
                                                       AND ((P_NCODIMERCA = -1 )
                                                                    OR 
                                                            (LAQRECEP.NCODIRECEP IN 
                                                                           (SELECT LAQRECMER.NCODIRECEP 
                                                                              FROM LAQRECMER 
                                                                             WHERE LAQRECMER.NCODIMERCA = P_NCODIMERCA)))
                                                     ORDER BY LAQRECEP.DDATARECEP) LAQRECEP
                                             ) LAQRECEP        
                                                     
                                     WHERE REGISTRO >= P_MINROWNUM
                                       AND REGISTRO <= P_MAXROWNUM) 
                  LOOP
                    IF V_CONTADOR = 0 THEN
                    
                      V_HEADER := V_HEADER ||
                                  '<th colspan="2"    class="t-Report-colHead" > Recibido por:</th>';
                    
                    END IF;
                    V_CONTADOR := 1;
                    V_HEADER   := V_HEADER ||
                                  '<th colspan="3"   class="t-Report-colHead2" >' ||
                                  C_HEADERS.CNOMEUSUAR || '</th>';
                  END LOOP;
                 V_CONTADOR := 5 -V_COUNT_REGISTRO;
                  FOR RELLENO IN 1..V_CONTADOR LOOP
                     
                 V_HEADER := V_HEADER || ' <th colspan="3" class="t-Report-colHead2">-</th>';
                 
                 END LOOP;
                
                ELSIF I = 5 THEN
                 
                
                   V_CONTADOR := 0;
                
                  FOR C_HEADERS IN (SELECT *
                                      FROM (SELECT LAQRECEP.*, ROWNUM REGISTRO
                                              FROM (SELECT LAQRECEP.DDATARECEP, LAQRECEP.CETAPRECP 
                                                      FROM LAQRECEP, PERPERSO, LAQTPORIG
                                                     WHERE LAQRECEP.CSITURECEP = 'A'
                                                     AND ((P_NCODITPETAP = -1)
                                                             OR
                                                          (LAQRECEP.NCODITPETAP = P_NCODITPETAP))
                                                       
                                                       AND LAQRECEP.NPESORECP = PERPERSO.NCODIPERSO
                                                       AND LAQRECEP.NCODITPORIG = P_NCODITPORIG
                                                       AND LAQRECEP.NCODITPORIG = LAQTPORIG.NCODITPORIG
                                                       AND INSTR(UPPER(LAQRECEP.CLOTERECEP), UPPER(P_CLOTERECEP)) > 0 --|| C_COLUNAS.NCODIRECEP||
                                                       AND ((P_NCODIMERCA = -1 )
                                                              OR 
                                                              (LAQRECEP.NCODIRECEP IN 
                                                                     (SELECT LAQRECMER.NCODIRECEP 
                                                                        FROM LAQRECMER 
                                                                       WHERE LAQRECMER.NCODIMERCA = P_NCODIMERCA)))
                                                     ORDER BY LAQRECEP.DDATARECEP)LAQRECEP
                                             )LAQRECEP        
                                     WHERE REGISTRO >= P_MINROWNUM
                                       AND REGISTRO <= P_MAXROWNUM) 
                 LOOP
                    IF V_CONTADOR = 0 THEN
                    
                      V_HEADER := V_HEADER ||
                                  '<th colspan="2"  class="t-Report-colHead" >Etapa</th>';
                    
                    END IF;
                    V_CONTADOR := 1;
                    V_HEADER   := V_HEADER ||
                                  '<th colspan="3"   class="t-Report-colHead2" >' ||
                                  C_HEADERS.CETAPRECP || '</th>';
                  END LOOP;
                     V_CONTADOR := 5 -V_COUNT_REGISTRO;
                      FOR RELLENO IN 1..V_CONTADOR LOOP
                     
                 V_HEADER := V_HEADER || ' <th colspan="3" class="t-Report-colHead2">-</th>';
                 
                 END LOOP;
                ELSIF I = 6 THEN
                V_CONTADOR := 0;
                
                  FOR C_HEADERS IN (SELECT *
                                      FROM (
                                            SELECT LAQRECEP.*, ROWNUM REGISTRO
                                              FROM (SELECT LAQRECEP.DDATARECEP, LAQRECEP.CCIL_RECEP
                                                      FROM LAQRECEP, PERPERSO, LAQTPORIG
                                                     WHERE LAQRECEP.CSITURECEP = 'A'
                                                       AND LAQRECEP.NPESORECP = PERPERSO.NCODIPERSO
                                                       AND LAQRECEP.NCODITPORIG = P_NCODITPORIG
                                                       AND LAQRECEP.NCODITPORIG = LAQTPORIG.NCODITPORIG
                                                       AND ((P_NCODITPETAP = -1)
                                                                    OR
                                                            (LAQRECEP.NCODITPETAP = P_NCODITPETAP))
                                                   
                                                       AND INSTR(UPPER(LAQRECEP.CLOTERECEP), UPPER(P_CLOTERECEP)) > 0 --|| C_COLUNAS.NCODIRECEP||
                                                       AND ((P_NCODIMERCA = -1 )
                                                              OR 
                                                              (LAQRECEP.NCODIRECEP IN 
                                                                     (SELECT LAQRECMER.NCODIRECEP 
                                                                        FROM LAQRECMER 
                                                                       WHERE LAQRECMER.NCODIMERCA = P_NCODIMERCA)))
                                                     ORDER BY LAQRECEP.DDATARECEP)LAQRECEP
                                             )LAQRECEP        
                                     WHERE REGISTRO >= P_MINROWNUM
                                       AND REGISTRO <= P_MAXROWNUM) 
                  LOOP
                    IF V_CONTADOR = 0 THEN
                    
                      V_HEADER := V_HEADER ||
                                  '<th colspan="2"    class="t-Report-colHead" > CIL:</th>';
                    
                    END IF;
                    V_CONTADOR := 1;
                    V_HEADER   := V_HEADER ||
                                  '<th colspan="3"   class="t-Report-colHead2" >' ||
                                  C_HEADERS.CCIL_RECEP || '</th>';
                  END LOOP;
                     V_CONTADOR := 5 -V_COUNT_REGISTRO;
                      FOR RELLENO IN 1..V_CONTADOR LOOP
                     
                 V_HEADER := V_HEADER || ' <th colspan="3" class="t-Report-colHead2">-</th>';
                 
                 END LOOP;
                ELSIF I = 7 THEN
                  V_CONTADOR := 0;
                
                  FOR C_HEADERS IN (SELECT *
                                      FROM (SELECT LAQRECEP.*,  ROWNUM REGISTRO
                                              FROM (SELECT LAQRECEP.DDATARECEP,LAQRECEP.NCODIRECEP
                                                      FROM LAQRECEP, PERPERSO, LAQTPORIG
                                                     WHERE LAQRECEP.CSITURECEP = 'A'
                                                       AND ((P_NCODITPETAP = -1)
                                                                          OR
                                                            (LAQRECEP.NCODITPETAP = P_NCODITPETAP))
                                                         
                                                       AND LAQRECEP.NPESORECP = PERPERSO.NCODIPERSO
                                                       AND LAQRECEP.NCODITPORIG = P_NCODITPORIG
                                                       AND LAQRECEP.NCODITPORIG =  LAQTPORIG.NCODITPORIG
                                                       AND INSTR(UPPER(LAQRECEP.CLOTERECEP), UPPER(P_CLOTERECEP)) > 0 --|| C_COLUNAS.NCODIRECEP||
                                                       AND ((P_NCODIMERCA = -1 )
                                                              OR 
                                                              (LAQRECEP.NCODIRECEP IN 
                                                                     (SELECT LAQRECMER.NCODIRECEP 
                                                                        FROM LAQRECMER 
                                                                       WHERE LAQRECMER.NCODIMERCA = P_NCODIMERCA)))
                                                     ORDER BY LAQRECEP.DDATARECEP)LAQRECEP
                                            )LAQRECEP         
                                     WHERE REGISTRO >= P_MINROWNUM
                                       AND REGISTRO <= P_MAXROWNUM) 
                  LOOP
                    IF V_CONTADOR = 0 THEN
                    
                      V_HEADER := V_HEADER ||
                                  '<th colspan="1"    align="center"  class="t-Report-colHead VER" >Parametro</th><th colspan="1"    align="center"  class="t-Report-colHead VER" >Rango</th>';
                    
                    END IF;
                    V_CONTADOR := 1;
                    V_HEADER   := V_HEADER ||
                                  '<th class="t-Report-colHead2 VER" ><b>Resultado</b> </th><th class="t-Report-colHead2 VER" ><b>C/NC</b> </th><th class="t-Report-colHead2 VER"><b>Analista</b> </th>';
                  END LOOP;
                     V_CONTADOR := 5 -V_COUNT_REGISTRO;
                      FOR RELLENO IN 1..V_CONTADOR LOOP
                     
                 V_HEADER := V_HEADER || '<th class="t-Report-colHead2 VER" ><b>Resultado</b> </th><th class="t-Report-colHead2 VER" ><b>C/NC</b> </th><th class="t-Report-colHead2 VER"><b>Analista</b> </th>';
                 
                 END LOOP;
                END IF;
              
                V_HEADER := V_HEADER || '</tr>';
              
              END LOOP;
              V_CONTADOR := 0;
              FOR C_TIPO_ANALISIS IN (SELECT DISTINCT LAQTPANA.NCODITPANA, LAQTPANA.CDESCTPANA || ' ' ||  CASE TO_NUMBER(LAQTPANA.NCODITPANA)  
                                                                                                            WHEN 10 THEN   SEGUIMIENTO_RESULTADOS_PACK.FGET_ANAL_ACTIVO(P_NCODIRECEP =>  fget_lastOrFirt_ncodirep(P_CLOTERECEP,'L', P_NCODIMERCA => P_NCODIMERCA) ,   P_ROWNUM => 1)  
                                                                                                            WHEN 81 THEN   SEGUIMIENTO_RESULTADOS_PACK.FGET_ANAL_ACTIVO(P_NCODIRECEP =>  fget_lastOrFirt_ncodirep(P_CLOTERECEP,'L' , P_NCODIMERCA => P_NCODIMERCA) ,   P_ROWNUM => 1)
                                                                                                            WHEN 14 THEN   SEGUIMIENTO_RESULTADOS_PACK.FGET_ANAL_ACTIVO(P_NCODIRECEP =>  fget_lastOrFirt_ncodirep(P_CLOTERECEP,'L', P_NCODIMERCA => P_NCODIMERCA) ,   P_ROWNUM => 2)
                                                                                                            WHEN 82 THEN   SEGUIMIENTO_RESULTADOS_PACK.FGET_ANAL_ACTIVO(P_NCODIRECEP =>  fget_lastOrFirt_ncodirep(P_CLOTERECEP,'L', P_NCODIMERCA => P_NCODIMERCA) ,   P_ROWNUM => 2)
                                                                                                            WHEN 15 THEN   SEGUIMIENTO_RESULTADOS_PACK.FGET_ANAL_ACTIVO(P_NCODIRECEP =>  fget_lastOrFirt_ncodirep(P_CLOTERECEP,'L', P_NCODIMERCA => P_NCODIMERCA) ,   P_ROWNUM => 3) 
                                                                                                            WHEN 83 THEN   SEGUIMIENTO_RESULTADOS_PACK.FGET_ANAL_ACTIVO(P_NCODIRECEP =>  fget_lastOrFirt_ncodirep(P_CLOTERECEP,'L', P_NCODIMERCA => P_NCODIMERCA) ,   P_ROWNUM => 3)
                                                                                                            WHEN 20 THEN   SEGUIMIENTO_RESULTADOS_PACK.FGET_ANAL_ACTIVO(P_NCODIRECEP =>  fget_lastOrFirt_ncodirep(P_CLOTERECEP,'L', P_NCODIMERCA => P_NCODIMERCA) ,   P_ROWNUM => 4) 
                                                                                                            WHEN 84 THEN   SEGUIMIENTO_RESULTADOS_PACK.FGET_ANAL_ACTIVO(P_NCODIRECEP =>  fget_lastOrFirt_ncodirep(P_CLOTERECEP,'L', P_NCODIMERCA => P_NCODIMERCA) ,   P_ROWNUM => 4) 
                                                                                                            WHEN 21 THEN   SEGUIMIENTO_RESULTADOS_PACK.FGET_ANAL_ACTIVO(P_NCODIRECEP =>  fget_lastOrFirt_ncodirep(P_CLOTERECEP,'L', P_NCODIMERCA => P_NCODIMERCA),    P_ROWNUM => 5)
                                                                                                            WHEN 85 THEN   SEGUIMIENTO_RESULTADOS_PACK.FGET_ANAL_ACTIVO(P_NCODIRECEP =>  fget_lastOrFirt_ncodirep(P_CLOTERECEP,'L', P_NCODIMERCA => P_NCODIMERCA),    P_ROWNUM => 5)
                                                                                                            WHEN 89 THEN   SEGUIMIENTO_RESULTADOS_PACK.FGET_ANAL_ACTIVO(P_NCODIRECEP =>  fget_lastOrFirt_ncodirep(P_CLOTERECEP,'L', P_NCODIMERCA => P_NCODIMERCA) ,   P_ROWNUM => 6) 
                                                                                                           END  CDESCTPANA 
                                        FROM LAQTPANA
                                       WHERE LAQTPANA.Ncoditpana IN  (SELECT LAQITANAL.Ncoditpana
                                                                        FROM LAQITANAL, LAQRECEP, LAQRECANAL
                                                                       WHERE LAQITANAL.NCODIANALI = LAQRECANAL.NCODIANALI
                                                                         AND LAQRECEP.NCODIRECEP = LAQRECANAL.NCODIRECEP
                                                                         AND LAQRECANAL.NCODIRECEP IN (SELECT RECEP.NCODIRECEP
                                                                                                         FROM (
                                                                                                                SELECT RECEP.NCODIRECEP, ROWNUM REGISTRO
                                                                                                                  FROM (SELECT RECEP.NCODIRECEP
                                                                                                                          FROM LAQRECEP RECEP, PERPERSO, LAQTPORIG
                                                                                                                         WHERE RECEP.CSITURECEP = 'A'
                                                                                                                           AND RECEP.NPESORECP = PERPERSO.NCODIPERSO
                                                                                                                           AND RECEP.NCODITPORIG = P_NCODITPORIG
                                                                                                                           AND RECEP.NCODITPORIG = LAQTPORIG.NCODITPORIG
                                                                                                                           AND ((P_NCODITPETAP = -1)
                                                                                                                                 OR
                                                                                                                                (RECEP.NCODITPETAP = P_NCODITPETAP))
                                                                                                                             
                                                                                                                           AND INSTR(UPPER(RECEP.CLOTERECEP), UPPER(P_CLOTERECEP)) > 0 --|| C_COLUNAS.NCODIRECEP||
                                                                                                                           AND ((P_NCODIMERCA = -1 )
                                                                                                                                  OR 
                                                                                                                                  (RECEP.NCODIRECEP IN 
                                                                                                                                         (SELECT LAQRECMER.NCODIRECEP 
                                                                                                                                            FROM LAQRECMER 
                                                                                                                                           WHERE LAQRECMER.NCODIMERCA = P_NCODIMERCA)))
                                                                                                                         ORDER BY RECEP.DDATARECEP)RECEP
                                                                                                                   )RECEP
                                                                                                         WHERE REGISTRO >= P_MINROWNUM
                                                                                                           AND REGISTRO <= P_MAXROWNUM)
                                                                         AND INSTR(UPPER(LAQRECEP.CLOTERECEP), UPPER(P_CLOTERECEP)) > 0)
                                          ORDER BY LAQTPANA.NORDETPANA) 
              LOOP
              
                V_TABLE_BODY := V_TABLE_BODY ||
                                '<tr  id="utima_linea" ><td  class="t-Report-cell"  align="left"  colspan="1" >' ||
                                C_TIPO_ANALISIS.CDESCTPANA || '</td>';
              
                FOR C_RANGO IN (SELECT DISTINCT MAX(CAVLOMEPAANA)  CAVLOMEPAANA
                                  FROM (SELECT LAQRECEP.*, ROWNUM REGISTRO
                                          FROM (
                                                 SELECT NVL((SELECT DISTINCT NVL(LAQMEPAANA.CAVLOMEPAANA,'SIN RANGO') 
                                                                        FROM LAQMEPAANA, LAQTPANA, LAQRECMER
                                                                       WHERE LAQMEPAANA.NCODITPANA = LAQTPANA.NCODITPANA
                                                                         AND LAQMEPAANA.NCODIMERCA = LAQRECMER.NCODIMERCA
                                                                         AND LAQMEPAANA.NCODITPANA = C_TIPO_ANALISIS.NCODITPANA
                                                                         and LAQMEPAANA.NCODITPETAP = LAQRECEP.NCODITPETAP
                                                                         AND LAQRECMER.NCODIRECEP = LAQRECEP.NCODIRECEP),'SIN RANGO')  CAVLOMEPAANA,
                                                       
                                                       (SELECT LAQRECMER.NCODIMERCA
                                                          FROM LAQRECMER
                                                         WHERE LAQRECMER.NCODIRECEP = LAQRECEP.NCODIRECEP) NCODIMERCA
                                                  FROM LAQRECEP, PERPERSO, LAQTPORIG
                                                 WHERE LAQRECEP.CSITURECEP = 'A'
                                                   AND LAQRECEP.NPESORECP = PERPERSO.NCODIPERSO
                                                   AND ((P_NCODITPETAP = -1)
                                                         OR
                                                        (LAQRECEP.NCODITPETAP = P_NCODITPETAP))
                                                       
                                                   AND LAQRECEP.NCODITPORIG = P_NCODITPORIG
                                                   AND LAQRECEP.NCODITPORIG = LAQTPORIG.NCODITPORIG
                                                   AND INSTR(UPPER(LAQRECEP.CLOTERECEP), UPPER(P_CLOTERECEP)) > 0 --|| C_COLUNAS.NCODIRECEP||
                                                   AND ((P_NCODIMERCA = -1 )
                                                              OR 
                                                              (LAQRECEP.NCODIRECEP IN 
                                                                     (SELECT LAQRECMER.NCODIRECEP 
                                                                        FROM LAQRECMER 
                                                                       WHERE LAQRECMER.NCODIMERCA = P_NCODIMERCA)))
                                                 ORDER BY LAQRECEP.DDATARECEP
                                                )LAQRECEP
                                         
                                    )
                                 WHERE REGISTRO >= P_MINROWNUM
                                   AND REGISTRO <= P_MAXROWNUM) 
               LOOP
                
                  V_TABLE_BODY := V_TABLE_BODY ||
                                  '<td  class="t-Report-cell"  align="center"  colspan="1" >' ||
                                  C_RANGO.CAVLOMEPAANA || '</td>';
                
                END LOOP;
                V_CONTADOR := 0 ;
                FOR C_REPECPCION IN (SELECT *
                                       FROM (
                                             SELECT LAQRECEP.*, ROWNUM REGISTRO
                                               FROM (SELECT LAQRECEP.NCODIRECEP
                                                       FROM LAQRECEP, PERPERSO, LAQTPORIG
                                                      WHERE LAQRECEP.CSITURECEP = 'A'
                                                        AND LAQRECEP.NPESORECP = PERPERSO.NCODIPERSO
                                                        AND LAQRECEP.NCODITPORIG = P_NCODITPORIG
                                                        AND LAQRECEP.NCODITPORIG = LAQTPORIG.NCODITPORIG
                                                        AND ((P_NCODITPETAP = -1)
                                                              OR
                                                             (LAQRECEP.NCODITPETAP = P_NCODITPETAP))
                                                       
                                                        AND INSTR(UPPER(LAQRECEP.CLOTERECEP),  UPPER(P_CLOTERECEP)) > 0 --|| C_COLUNAS.NCODIRECEP||
                                                        AND ((P_NCODIMERCA = -1 )
                                                              OR 
                                                              (LAQRECEP.NCODIRECEP IN 
                                                                     (SELECT LAQRECMER.NCODIRECEP 
                                                                        FROM LAQRECMER 
                                                                       WHERE LAQRECMER.NCODIMERCA = P_NCODIMERCA)))
                                                      ORDER BY LAQRECEP.DDATARECEP)LAQRECEP
                                              )LAQRECEP
                                      WHERE REGISTRO >= P_MINROWNUM
                                        AND REGISTRO <= P_MAXROWNUM) 
                 LOOP 
                  -- V_TABLE_BODY := V_TABLE_BODY ||'<td   style="width:60px;display:inline-block;"  colspan="2"  ><b>Parametro</b> </td><td   style="width:60px;display:inline-block;" ><b>Resultado</b> </td><td   style="width:60px;display:inline-block;" ><b>C/NC</b> </td><td   style="width:60px;display:inline-block;" ><b>Analista</b> </td>';
                    FOR C_RESULTADOS IN (SELECT F_GETSEGUIMIENTORESULTDOS('R',
                                                                          C_REPECPCION.NCODIRECEP,
                                                                          C_TIPO_ANALISIS.NCODITPANA) CVALOITANAL,
                                                F_GETSEGUIMIENTORESULTDOS('C',
                                                                          C_REPECPCION.NCODIRECEP,
                                                                          C_TIPO_ANALISIS.NCODITPANA) CCUMPITANAL,
                                                F_GETSEGUIMIENTORESULTDOS('A',
                                                                          C_REPECPCION.NCODIRECEP,
                                                                          C_TIPO_ANALISIS.NCODITPANA) ANALISTA
                                           FROM DUAL) LOOP
                    
                      V_TABLE_BODY := V_TABLE_BODY ||
                                      '<td class="t-Report-cell"   align="center" >' ||
                                      C_RESULTADOS.CVALOITANAL || '</td>' ||
                                      '<td  class="t-Report-cell"   align="center"  >' ||
                                      C_RESULTADOS.CCUMPITANAL || '</td>' ||
                                      '<td  class="t-Report-cell"   align="center"  >' ||
                                      C_RESULTADOS.ANALISTA || '</td>';
                    
                    END LOOP;
                    
                  
                    
                   
                
                END LOOP;
                  V_CONTADOR := 5 - V_COUNT_REGISTRO;
                FOR RELLENO IN 1..V_CONTADOR LOOP
                      
                     V_TABLE_BODY:=   V_TABLE_BODY || ' <td class="t-Report-cell" align="center">-</td><td class="t-Report-cell" align="center">-</td><td class="t-Report-cell" align="center">-</td>';
                    
                    END LOOP;
                V_TABLE_BODY := V_TABLE_BODY || '</tr>';
              
              END LOOP;
            V_CONTADOR := 0;
              FOR C_REPECPCION IN (SELECT *
                                     FROM (
                                           SELECT LAQRECEP.*,
                                                  ROWNUM REGISTRO
                                             FROM (SELECT F_GETOBSRECEPCION(LAQRECEP.NCODIRECEP) OBS
                                                     FROM LAQRECEP, PERPERSO, LAQTPORIG
                                                    WHERE LAQRECEP.CSITURECEP = 'A'
                                                      AND LAQRECEP.NPESORECP = PERPERSO.NCODIPERSO
                                                      AND LAQRECEP.NCODITPORIG = P_NCODITPORIG
                                                      AND LAQRECEP.NCODITPORIG = LAQTPORIG.NCODITPORIG
                                                      AND ((P_NCODITPETAP = -1)
                                                                        OR
                                                          (LAQRECEP.NCODITPETAP = P_NCODITPETAP))
                                                       
                                                      AND INSTR(UPPER(LAQRECEP.CLOTERECEP), UPPER(P_CLOTERECEP)) > 0 --|| C_COLUNAS.NCODIRECEP||
                                                      AND ((P_NCODIMERCA = -1 )
                                                              OR 
                                                              (LAQRECEP.NCODIRECEP IN 
                                                                     (SELECT LAQRECMER.NCODIRECEP 
                                                                        FROM LAQRECMER 
                                                                       WHERE LAQRECMER.NCODIMERCA = P_NCODIMERCA)))
                                                    ORDER BY LAQRECEP.DDATARECEP)LAQRECEP
                                            )LAQRECEP
                                    WHERE REGISTRO >= P_MINROWNUM
                                      AND REGISTRO <= P_MAXROWNUM) 
              LOOP
              
                IF V_CONTADOR = 0 THEN
                
                  V_TABLE_FOOTER := V_TABLE_FOOTER ||
                                    '</tr><tr><td  class="t-Report-cell"   align="center"   colspan="2">Observaciones</td>';
                
                END IF;
                V_CONTADOR     := 1;
                V_TABLE_FOOTER := V_TABLE_FOOTER ||
                                  '<td class="t-Report-cell"   align="center"   colspan="3"  >' ||
                                  nvl(C_REPECPCION.OBS,'-') || '</td>';
              
              END LOOP;
              V_CONTADOR := 5 -V_COUNT_REGISTRO;
                    
                    FOR RELLENO IN 1..V_CONTADOR LOOP
                      
                     V_TABLE_FOOTER:=      V_TABLE_FOOTER || '<td class="t-Report-cell"   align="center"   colspan="3"  >-</td>';
                    
                    END LOOP;
              V_HEADER := V_HEADER || V_TABLE_BODY || V_TABLE_FOOTER ||
                          '</td></tr>' || '</table><div><h1><b>C: Cumple con el rango de referencia; NC: No cumple con el rango de referencia. Los resultados se relacionan unicamente a las muestras recibidas en el Laboratorio.</b><h1></div></body></html>';
              v_return := V_HEADER;
              
              
              
            ELSIF P_TPFORMSEARCH = 'E' THEN
              FOR I IN 1 .. 7 LOOP
                V_HEADER := V_HEADER || ' <tr class="t-Report-cell">';
                IF I = 1 THEN
                  V_CONTADOR := 0;
                  FOR C_HEADERS IN (SELECT *
                                      FROM (
                                            SELECT LAQRECEP.*, ROWNUM REGISTRO
                                              FROM (SELECT PERPERSO.CNOMEPERSO
                                                      FROM LAQRECEP, PERPERSO, LAQTPORIG
                                                     WHERE LAQRECEP.CSITURECEP = 'A'
                                                       AND LAQRECEP.NPESORECP = PERPERSO.NCODIPERSO
                                                       AND LAQRECEP.NCODITPORIG = P_NCODITPORIG
                                                       AND LAQRECEP.NCODITPORIG = LAQTPORIG.NCODITPORIG
                                                       AND ((P_NCODITPETAP = -1)
                                                                      OR
                                                        (LAQRECEP.NCODITPETAP = P_NCODITPETAP))
                                                     
                                                       AND UPPER(LAQRECEP.CLOTERECEP) = UPPER(P_CLOTERECEP) --|| C_COLUNAS.NCODIRECEP||
                                                       AND ((P_NCODIMERCA = -1 )
                                                              OR 
                                                              (LAQRECEP.NCODIRECEP IN 
                                                                     (SELECT LAQRECMER.NCODIRECEP 
                                                                        FROM LAQRECMER 
                                                                       WHERE LAQRECMER.NCODIMERCA = P_NCODIMERCA)))
                                                     ORDER BY LAQRECEP.DDATARECEP)LAQRECEP
                                           )LAQRECEP
                                     WHERE REGISTRO >= P_MINROWNUM
                                       AND REGISTRO <= P_MAXROWNUM
                                     order by REGISTRO) 
                  LOOP
                    IF V_CONTADOR = 0 THEN
                      V_HEADER := V_HEADER ||
                                  '<th colspan="2"   class="t-Report-colHead" > Solicitado Por:</th>';
                    
                    END IF;
                    V_HEADER   := V_HEADER ||
                                  '<th colspan="3"   class="t-Report-colHead2" >' ||
                                  C_HEADERS.CNOMEPERSO || '</th>';
                    V_CONTADOR := 1;
                  END LOOP;
                
                ELSIF I = 2 THEN
                  V_CONTADOR := 0;
                  FOR C_HEADERS IN (SELECT *
                                      FROM (
                                            SELECT LAQRECEP.*, ROWNUM REGISTRO
                                              FROM (SELECT to_char(LAQRECEP.DDATARECEP,'DD-MM-YYYY')DDATARECEP
                                                      FROM LAQRECEP, PERPERSO, LAQTPORIG
                                                     WHERE LAQRECEP.CSITURECEP = 'A'
                                                       AND LAQRECEP.NPESORECP = PERPERSO.NCODIPERSO
                                                       AND LAQRECEP.NCODITPORIG = P_NCODITPORIG
                                                       AND LAQRECEP.NCODITPORIG = LAQTPORIG.NCODITPORIG
                                                       AND ((P_NCODITPETAP = -1)
                                                                OR
                                                           (LAQRECEP.NCODITPETAP = P_NCODITPETAP))
                                                     
                                                       AND UPPER(LAQRECEP.CLOTERECEP) = UPPER(P_CLOTERECEP) --|| C_COLUNAS.NCODIRECEP||
                                                       AND ((P_NCODIMERCA = -1 )
                                                              OR 
                                                              (LAQRECEP.NCODIRECEP IN 
                                                                     (SELECT LAQRECMER.NCODIRECEP 
                                                                        FROM LAQRECMER 
                                                                       WHERE LAQRECMER.NCODIMERCA = P_NCODIMERCA)))
                                                     ORDER BY LAQRECEP.DDATARECEP)LAQRECEP
                                             )LAQRECEP
                                     WHERE REGISTRO >= P_MINROWNUM
                                       AND REGISTRO <= P_MAXROWNUM) 
                 LOOP
                    IF V_CONTADOR = 0 THEN
                    
                      V_HEADER := V_HEADER ||
                                  '<th colspan="2"  class="t-Report-colHead" > Fecha:</th>';
                    
                    END IF;
                    V_HEADER   := V_HEADER ||
                                  '<th colspan="3"  class="t-Report-colHead2" >' ||
                                  C_HEADERS.DDATARECEP || '</th>';
                    V_CONTADOR := 1;
                  END LOOP;
                ELSIF I = 3 THEN
                  V_CONTADOR := 0;
                
                  FOR C_HEADERS IN (SELECT LAQRECEP.*
                                      FROM (
                                            SELECT LAQRECEP.*, ROWNUM REGISTRO
                                              FROM (SELECT to_CHAR(LAQRECEP.DDATARECEP, 'HH24:MI') HORA
                                                      FROM LAQRECEP, PERPERSO, LAQTPORIG
                                                     WHERE LAQRECEP.CSITURECEP = 'A'
                                                       AND LAQRECEP.NPESORECP = PERPERSO.NCODIPERSO
                                                       AND LAQRECEP.NCODITPORIG =  P_NCODITPORIG
                                                       AND LAQRECEP.NCODITPORIG = LAQTPORIG.NCODITPORIG
                                                       AND ((P_NCODITPETAP = -1)
                                                            OR
                                                           (LAQRECEP.NCODITPETAP = P_NCODITPETAP))
                                                       
                                                       AND UPPER(LAQRECEP.CLOTERECEP) = UPPER(P_CLOTERECEP) --|| C_COLUNAS.NCODIRECEP||
                                                       AND ((P_NCODIMERCA = -1 )
                                                              OR 
                                                              (LAQRECEP.NCODIRECEP IN 
                                                                     (SELECT LAQRECMER.NCODIRECEP 
                                                                        FROM LAQRECMER 
                                                                       WHERE LAQRECMER.NCODIMERCA = P_NCODIMERCA)))
                                                     ORDER BY LAQRECEP.DDATARECEP)LAQRECEP
                                             )LAQRECEP
                                     WHERE REGISTRO >= P_MINROWNUM
                                       AND REGISTRO <= P_MAXROWNUM) 
                  LOOP
                    IF V_CONTADOR = 0 THEN
                    
                      V_HEADER := V_HEADER ||
                                  '<th colspan="2"  class="t-Report-colHead" > Hora:</th>';
                    
                    END IF;
                    V_CONTADOR := 1;
                    V_HEADER   := V_HEADER ||
                                  '<th colspan="3"  class="t-Report-colHead2" >' ||
                                  C_HEADERS.HORA || '</th>';
                  
                  END LOOP;
                  
                ELSIF I = 4 THEN
                  V_CONTADOR := 0;
                
                  FOR C_HEADERS IN (SELECT *
                                      FROM (
                                            SELECT LAQRECEP.*, ROWNUM REGISTRO
                                              FROM (SELECT SYSUSUAR.CNOMEUSUAR
                                                      FROM LAQRECEP, PERPERSO, LAQTPORIG , SYSUSUAR
                                                     WHERE LAQRECEP.CSITURECEP = 'A'
                                                       AND LAQRECEP.NCODIUSUAR = SYSUSUAR.NCODIUSUAR
                                                       AND LAQRECEP.NPESORECP = PERPERSO.NCODIPERSO
                                                       AND LAQRECEP.NCODITPORIG = P_NCODITPORIG
                                                       AND LAQRECEP.NCODITPORIG = LAQTPORIG.NCODITPORIG
                                                       AND ((P_NCODITPETAP = -1)
                                                             OR
                                                            (LAQRECEP.NCODITPETAP = P_NCODITPETAP))
                                                       AND UPPER(LAQRECEP.CLOTERECEP) = UPPER(P_CLOTERECEP) --|| C_COLUNAS.NCODIRECEP||
                                                       AND ((P_NCODIMERCA = -1 )
                                                              OR 
                                                              (LAQRECEP.NCODIRECEP IN 
                                                                     (SELECT LAQRECMER.NCODIRECEP 
                                                                        FROM LAQRECMER 
                                                                       WHERE LAQRECMER.NCODIMERCA = P_NCODIMERCA)))
                                                     ORDER BY LAQRECEP.DDATARECEP)LAQRECEP
                                            )LAQRECEP         
                                     WHERE REGISTRO >= P_MINROWNUM
                                       AND REGISTRO <= P_MAXROWNUM) 
                  LOOP
                    IF V_CONTADOR = 0 THEN
                    
                      V_HEADER := V_HEADER ||
                                  '<th colspan="2"    class="t-Report-colHead" > RECIBIDO POR:</th>';
                    
                    END IF;
                    V_CONTADOR := 1;
                    V_HEADER   := V_HEADER ||
                                  '<th colspan="3"   class="t-Report-colHead2" >' ||
                                  C_HEADERS.CNOMEUSUAR || '</th>';
                  END LOOP;
                   
                
                ELSIF I = 5 THEN
                
                 V_CONTADOR := 0;
                
                  FOR C_HEADERS IN (SELECT *
                                      FROM (
                                            SELECT LAQRECEP.*, ROWNUM REGISTRO
                                              FROM (SELECT LAQRECEP.CETAPRECP 
                                                      FROM LAQRECEP, PERPERSO, LAQTPORIG
                                                     WHERE LAQRECEP.CSITURECEP = 'A'
                                                       AND LAQRECEP.NPESORECP = PERPERSO.NCODIPERSO
                                                       AND LAQRECEP.NCODITPORIG = P_NCODITPORIG
                                                       AND LAQRECEP.NCODITPORIG = LAQTPORIG.NCODITPORIG
                                                       AND ((P_NCODITPETAP = -1)
                                                             OR
                                                            (LAQRECEP.NCODITPETAP = P_NCODITPETAP))
                                                           
                                                       AND UPPER(LAQRECEP.CLOTERECEP) = UPPER(P_CLOTERECEP) --|| C_COLUNAS.NCODIRECEP||
                                                       AND ((P_NCODIMERCA = -1 )
                                                              OR 
                                                              (LAQRECEP.NCODIRECEP IN 
                                                                     (SELECT LAQRECMER.NCODIRECEP 
                                                                        FROM LAQRECMER 
                                                                       WHERE LAQRECMER.NCODIMERCA = P_NCODIMERCA)))
                                                     ORDER BY LAQRECEP.DDATARECEP)LAQRECEP
                                             )LAQRECEP
                                     WHERE REGISTRO >= P_MINROWNUM
                                       AND REGISTRO <= P_MAXROWNUM) 
                  LOOP
                    IF V_CONTADOR = 0 THEN
                    
                      V_HEADER := V_HEADER ||
                                  '<th colspan="2"  class="t-Report-colHead" >Etapa</th>';
                    
                    END IF;
                    V_CONTADOR := 1;
                    V_HEADER   := V_HEADER ||
                                  '<th colspan="3"   class="t-Report-colHead2" >' ||
                                  C_HEADERS.CETAPRECP || '</th>';
                  END LOOP;
                ELSIF I = 6 THEN
                   V_CONTADOR := 0;
                
                  FOR C_HEADERS IN (SELECT *
                                      FROM (
                                            SELECT LAQRECEP.*, ROWNUM REGISTRO
                                              FROM (SELECT LAQRECEP.CCIL_RECEP
                                                      FROM LAQRECEP, PERPERSO, LAQTPORIG
                                                     WHERE LAQRECEP.CSITURECEP = 'A'
                                                       AND LAQRECEP.NPESORECP = PERPERSO.NCODIPERSO
                                                       AND LAQRECEP.NCODITPORIG = P_NCODITPORIG
                                                       AND LAQRECEP.NCODITPORIG = LAQTPORIG.NCODITPORIG
                                                       AND ((P_NCODITPETAP = -1)
                                                             OR
                                                            (LAQRECEP.NCODITPETAP = P_NCODITPETAP))
                                                       AND UPPER(LAQRECEP.CLOTERECEP) =  UPPER(P_CLOTERECEP) --|| C_COLUNAS.NCODIRECEP||
                                                       AND ((P_NCODIMERCA = -1 )
                                                              OR 
                                                              (LAQRECEP.NCODIRECEP IN 
                                                                     (SELECT LAQRECMER.NCODIRECEP 
                                                                        FROM LAQRECMER 
                                                                       WHERE LAQRECMER.NCODIMERCA = P_NCODIMERCA)))
                                                     ORDER BY LAQRECEP.DDATARECEP)LAQRECEP
                                           )LAQRECEP
                                     WHERE REGISTRO >= P_MINROWNUM
                                       AND REGISTRO <= P_MAXROWNUM) 
                  LOOP
                    IF V_CONTADOR = 0 THEN
                    
                      V_HEADER := V_HEADER ||
                                  '<th colspan="2"    class="t-Report-colHead" > CIL:</th>';
                    
                    END IF;
                    V_CONTADOR := 1;
                    V_HEADER   := V_HEADER ||
                                  '<th colspan="3"   class="t-Report-colHead2" >' ||
                                  C_HEADERS.CCIL_RECEP || '</th>';
                  END LOOP;
                ELSIF I = 7 THEN
                  V_CONTADOR := 0;
                
                  FOR C_HEADERS IN (SELECT *
                                      FROM (
                                            SELECT LAQRECEP.*, ROWNUM REGISTRO
                                              FROM (SELECT LAQRECEP.NCODIRECEP
                                                      FROM LAQRECEP, PERPERSO, LAQTPORIG
                                                     WHERE LAQRECEP.CSITURECEP = 'A'
                                                       AND LAQRECEP.NPESORECP = PERPERSO.NCODIPERSO
                                                       AND LAQRECEP.NCODITPORIG = P_NCODITPORIG
                                                       AND LAQRECEP.NCODITPORIG = LAQTPORIG.NCODITPORIG
                                                       AND ((P_NCODITPETAP = -1)
                                                             OR
                                                           (LAQRECEP.NCODITPETAP = P_NCODITPETAP))
                                                       
                                                       AND UPPER(LAQRECEP.CLOTERECEP) = UPPER(P_CLOTERECEP) --|| C_COLUNAS.NCODIRECEP||
                                                       AND ((P_NCODIMERCA = -1 )
                                                              OR 
                                                              (LAQRECEP.NCODIRECEP IN 
                                                                     (SELECT LAQRECMER.NCODIRECEP 
                                                                        FROM LAQRECMER 
                                                                       WHERE LAQRECMER.NCODIMERCA = P_NCODIMERCA)))
                                                     ORDER BY LAQRECEP.DDATARECEP)LAQRECEP
                                            )LAQRECEP
                                     WHERE REGISTRO >= P_MINROWNUM
                                       AND REGISTRO <= P_MAXROWNUM) LOOP
                    IF V_CONTADOR = 0 THEN
                    
                      V_HEADER := V_HEADER ||
                                  '<th colspan="1"    align="center"  class="t-Report-colHead" >Parametro</th><th colspan="1"    align="center"  class="t-Report-colHead" >Rango</th>';
                    
                    END IF;
                    V_CONTADOR := 1;
                    V_HEADER   := V_HEADER ||
                                  '<th class="t-Report-colHead2" ><b>Resultado</b> </th><th class="t-Report-colHead2" ><b>C/NC</b> </th><th class="t-Report-colHead2"><b>Analista</b> </th>';
                  END LOOP;
                END IF;
              
                V_HEADER := V_HEADER || '</tr>';
              
              END LOOP;
              V_CONTADOR := 0;
              FOR C_TIPO_ANALISIS IN (SELECT DISTINCT LAQTPANA.NCODITPANA,
                                                      LAQTPANA.CDESCTPANA
                                        FROM LAQTPANA
                                       WHERE LAQTPANA.Ncoditpana IN
                                                                   (SELECT LAQITANAL.Ncoditpana
                                                                      FROM LAQITANAL, LAQRECEP, LAQRECANAL
                                                                     WHERE LAQITANAL.NCODIANALI = LAQRECANAL.NCODIANALI
                                                                       AND LAQRECEP.NCODIRECEP = LAQRECANAL.NCODIRECEP
                                                                       AND LAQRECANAL.NCODIRECEP IN
                                                                                                     (SELECT NCODIRECEP
                                                                                                        FROM (
                                                                                                              SELECT NCODIRECEP, ROWNUM REGISTRO
                                                                                                                FROM (SELECT RECEP.NCODIRECEP
                                                                                                                        FROM LAQRECEP RECEP, PERPERSO, LAQTPORIG
                                                                                                                       WHERE RECEP.CSITURECEP = 'A'
                                                                                                                         AND RECEP.NPESORECP = PERPERSO.NCODIPERSO
                                                                                                                         AND RECEP.NCODITPORIG = P_NCODITPORIG
                                                                                                                         AND RECEP.NCODITPORIG = LAQTPORIG.NCODITPORIG
                                                                                                                         AND ((P_NCODITPETAP = -1)
                                                                                                                               OR
                                                                                                                               (RECEP.NCODITPETAP = P_NCODITPETAP))
                                                                                                                           
                                                                                                                         AND UPPER(RECEP.CLOTERECEP) = UPPER(P_CLOTERECEP) --|| C_COLUNAS.NCODIRECEP||
                                                                                                                         AND ((P_NCODIMERCA = -1 )
                                                                                                                                OR 
                                                                                                                                (RECEP.NCODIRECEP IN 
                                                                                                                                       (SELECT LAQRECMER.NCODIRECEP 
                                                                                                                                          FROM LAQRECMER 
                                                                                                                                         WHERE LAQRECMER.NCODIMERCA = P_NCODIMERCA)))
                                                                                                                       ORDER BY RECEP.DDATARECEP)RECEP
                                                                                                              )RECEP
                                                                                                       WHERE REGISTRO >= P_MINROWNUM
                                                                                                         AND REGISTRO <= P_MAXROWNUM)
                                                                       AND INSTR(UPPER(LAQRECEP.CLOTERECEP), UPPER(P_CLOTERECEP)) > 0)
                                          ORDER BY LAQTPANA.NORDETPANA) 
              LOOP
              
                V_TABLE_BODY := V_TABLE_BODY ||
                                '<tr  id="utima_linea" ><td  class="t-Report-cell" align="left"   colspan="1" >' ||
                                C_TIPO_ANALISIS.CDESCTPANA || '</td>';
              
                FOR C_RANGO IN (SELECT DISTINCT MAX(CAVLOMEPAANA) CAVLOMEPAANA
                                  FROM (SELECT LAQRECEP.*,
                                               ROWNUM REGISTRO
                                          FROM  (SELECT NVL((SELECT DISTINCT NVL(LAQMEPAANA.CAVLOMEPAANA,'SIN RANGO') 
                                                                FROM LAQMEPAANA, LAQTPANA, LAQRECMER
                                                               WHERE LAQMEPAANA.NCODITPANA = LAQTPANA.NCODITPANA
                                                                 AND LAQMEPAANA.NCODIMERCA = LAQRECMER.NCODIMERCA
                                                                 AND LAQMEPAANA.NCODITPANA = C_TIPO_ANALISIS.NCODITPANA
                                                                 and LAQMEPAANA.NCODITPETAP = LAQRECEP.NCODITPETAP
                                                                 AND LAQRECMER.NCODIRECEP = LAQRECEP.NCODIRECEP),'.SIN RANGO') CAVLOMEPAANA,
                                                         
                                                         (SELECT LAQRECMER.NCODIMERCA
                                                            FROM LAQRECMER
                                                           WHERE LAQRECMER.NCODIRECEP = LAQRECEP.NCODIRECEP) NCODIMERCA
                                                    FROM LAQRECEP, PERPERSO, LAQTPORIG
                                                   WHERE LAQRECEP.CSITURECEP = 'A'
                                                     AND LAQRECEP.NPESORECP = PERPERSO.NCODIPERSO
                                                     AND LAQRECEP.NCODITPORIG = P_NCODITPORIG
                                                     AND LAQRECEP.NCODITPORIG = LAQTPORIG.NCODITPORIG
                                                      AND ((P_NCODITPETAP = -1)
                                                            OR
                                                           (LAQRECEP.NCODITPETAP = P_NCODITPETAP))
                                                     AND UPPER(LAQRECEP.CLOTERECEP) = UPPER(P_CLOTERECEP) --|| C_COLUNAS.NCODIRECEP||
                                                     AND ((P_NCODIMERCA = -1 )
                                                              OR 
                                                              (LAQRECEP.NCODIRECEP IN 
                                                                     (SELECT LAQRECMER.NCODIRECEP 
                                                                        FROM LAQRECMER 
                                                                       WHERE LAQRECMER.NCODIMERCA = P_NCODIMERCA)))
                                                   ORDER BY LAQRECEP.DDATARECEP)LAQRECEP
                                                )LAQRECEP
                                            
                                 WHERE REGISTRO >= P_MINROWNUM
                                   AND REGISTRO <= P_MAXROWNUM) 
               LOOP
                
                  V_TABLE_BODY := V_TABLE_BODY ||
                                  '<td  class="t-Report-cell"  align="center"  colspan="1" >' ||
                                  C_RANGO.CAVLOMEPAANA || '</td>';
                
                END LOOP;
                FOR C_REPECPCION IN (SELECT *
                                       FROM (
                                             SELECT LAQRECEP.*, ROWNUM REGISTRO
                                               FROM (SELECT LAQRECEP.NCODIRECEP
                                                       FROM LAQRECEP, PERPERSO, LAQTPORIG
                                                      WHERE LAQRECEP.CSITURECEP = 'A'
                                                        AND LAQRECEP.NPESORECP = PERPERSO.NCODIPERSO
                                                        AND LAQRECEP.NCODITPORIG = P_NCODITPORIG
                                                        AND LAQRECEP.NCODITPORIG = LAQTPORIG.NCODITPORIG
                                                        AND ((P_NCODITPETAP = -1)
                                                             OR
                                                             (LAQRECEP.NCODITPETAP = P_NCODITPETAP))
                                                        AND UPPER(LAQRECEP.CLOTERECEP) = UPPER(P_CLOTERECEP) --|| C_COLUNAS.NCODIRECEP||
                                                        AND ((P_NCODIMERCA = -1 )
                                                              OR 
                                                              (LAQRECEP.NCODIRECEP IN 
                                                                     (SELECT LAQRECMER.NCODIRECEP 
                                                                        FROM LAQRECMER 
                                                                       WHERE LAQRECMER.NCODIMERCA = P_NCODIMERCA)))
                                                      ORDER BY LAQRECEP.DDATARECEP)LAQRECEP
                                            )LAQRECEP
                                      WHERE REGISTRO >= P_MINROWNUM
                                        AND REGISTRO <= P_MAXROWNUM) 
                LOOP
                  -- V_TABLE_BODY := V_TABLE_BODY ||'<td   style="width:60px;display:inline-block;"  colspan="2"  ><b>Parametro</b> </td><td   style="width:60px;display:inline-block;" ><b>Resultado</b> </td><td   style="width:60px;display:inline-block;" ><b>C/NC</b> </td><td   style="width:60px;display:inline-block;" ><b>Analista</b> </td>';
                  FOR C_RESULTADOS IN (SELECT F_GETSEGUIMIENTORESULTDOS('R',
                                                                        C_REPECPCION.NCODIRECEP,
                                                                        C_TIPO_ANALISIS.NCODITPANA) CVALOITANAL,
                                              F_GETSEGUIMIENTORESULTDOS('C',
                                                                        C_REPECPCION.NCODIRECEP,
                                                                        C_TIPO_ANALISIS.NCODITPANA) CCUMPITANAL,
                                              F_GETSEGUIMIENTORESULTDOS('A',
                                                                        C_REPECPCION.NCODIRECEP,
                                                                        C_TIPO_ANALISIS.NCODITPANA) ANALISTA
                                         FROM DUAL) LOOP
                  
                    V_TABLE_BODY := V_TABLE_BODY ||
                                    '<td class="t-Report-cell"   align="center" >' ||
                                    C_RESULTADOS.CVALOITANAL || '</td>' ||
                                    '<td  class="t-Report-cell"   align="center"  >' ||
                                    C_RESULTADOS.CCUMPITANAL || '</td>' ||
                                    '<td  class="t-Report-cell"   align="center"  >' ||
                                    C_RESULTADOS.ANALISTA || '</td>';
                  
                  END LOOP;
                
                END LOOP;
              
                V_TABLE_BODY := V_TABLE_BODY || '</tr>';
              
              END LOOP;
               V_CONTADOR:= 0;
              FOR C_REPECPCION IN (SELECT *
                                     FROM (
                                           SELECT LAQRECEP.*,  ROWNUM REGISTRO
                                             FROM (SELECT F_GETOBSRECEPCION(LAQRECEP.NCODIRECEP) OBS
                                                     FROM LAQRECEP, PERPERSO, LAQTPORIG
                                                    WHERE LAQRECEP.CSITURECEP = 'A'
                                                      AND LAQRECEP.NPESORECP = PERPERSO.NCODIPERSO
                                                      AND LAQRECEP.NCODITPORIG = P_NCODITPORIG
                                                      AND LAQRECEP.NCODITPORIG = LAQTPORIG.NCODITPORIG
                                                      AND ((P_NCODITPETAP = -1)
                                                           OR
                                                           (LAQRECEP.NCODITPETAP = P_NCODITPETAP))
                                                      AND UPPER(LAQRECEP.CLOTERECEP) =  UPPER(P_CLOTERECEP) --|| C_COLUNAS.NCODIRECEP||
                                                      AND ((P_NCODIMERCA = -1 )
                                                              OR 
                                                              (LAQRECEP.NCODIRECEP IN 
                                                                     (SELECT LAQRECMER.NCODIRECEP 
                                                                        FROM LAQRECMER 
                                                                       WHERE LAQRECMER.NCODIMERCA = P_NCODIMERCA)))
                                                    ORDER BY LAQRECEP.DDATARECEP)LAQRECEP
                                          )LAQRECEP
                                    WHERE REGISTRO >= P_MINROWNUM
                                      AND REGISTRO <= P_MAXROWNUM) 
                LOOP
              
                IF V_CONTADOR = 0 THEN
                
                  V_TABLE_FOOTER := V_TABLE_FOOTER ||
                                    '</tr><tr><td  class="t-Report-cell"   align="center"   colspan="2">Observaciones</td>';
                
                END IF;
                V_CONTADOR     := 1;
                V_TABLE_FOOTER := V_TABLE_FOOTER ||
                                  '<td class="t-Report-cell"   align="center"   colspan="3"  >' ||
                                  NVL(C_REPECPCION.OBS,'-') || '</td>';
              
              END LOOP;
              V_HEADER := V_HEADER || V_TABLE_BODY || V_TABLE_FOOTER ||
                          '</td></tr>' || '</table><div><h1><b>C: Cumple con el rango de referencia; NC: No cumple con el rango de referencia. Los resultados se relacionan unicamente a las muestras recibidas en el Laboratorio.</b><h1></div></div></body></html>';
              v_return := V_HEADER;
            END IF;
            RETURN v_return;
            
            
          ELSE  
             RETURN NULL ;
          end if;
          
          
          EXCEPTION 
             WHEN OTHERS THEN 
                RETURN NULL ;
        end;