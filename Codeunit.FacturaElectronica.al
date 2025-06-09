codeunit 56003 "Factura Electronica"
{
    Permissions = TableData "Sales Invoice Header" = rm,
                  TableData "Sales Cr.Memo Header" = rimd;

    trigger OnRun()
    begin
    end;

    var
/*         XmlNode: Automation; */
        TempInstream: InStream;
        rCodAlmacen: Record Location;
        rConfSant: Record "Config. Empresa";
        Moneda: Code[20];
        rGLS: Record "General Ledger Setup";
        Tasa: Decimal;
        txtTasa: Text[30];
        txtValorNeto: Text[30];
        txtIVA: Text[30];
        txtTotal: Text[30];
        DtoLin: Decimal;
        DtoFact: Decimal;
        txtDtoFact: Text[30];
        rVatEntry: Record "VAT Entry";
        Exento: Decimal;
        txtExento: Text[30];
        CabEnvio: Text[900];
        LinEnvio: array[50] of Text[1024];
        I1: Integer;
        I: Integer;
        txtCant: Text[30];
        txtPrecio: Text[30];
        txtImp: Text[30];
        NoFact: Code[20];
        TotalDescuentos: Decimal;
        k: Integer;
        ParteNumerica: Code[20];
        ParteSerie: Code[20];
        Encontrado: Boolean;
        Serie: Code[10];
        Text003: Label 'The digital stamp was not generated correctly. Go to the registered invoice and try to generate it.';
        rNoSeriesLine: Record "No. Series Line";
        p1: Text[1024];
        p2: Text[1024];
        TG: Code[1];
        txt0001: Label 'There was a communication error';
        Concepto: Text[30];
        ValorDescLin: Decimal;
        NoFactRel: Text[30];
        SerieRel: Text[30];
        DtoLinTotal: Decimal;
        DtoFactTotal: Decimal;
        Error001: Label 'This Invoice has no digital seal';
        txt002: Label 'Folio successfully Voided';
        txt004: Label 'The Folio is not properly voided. Go to the XML file and check';


    procedure Factura(rSIH: Record "Sales Invoice Header")
    var
        rSIL: Record "Sales Invoice Line";
    /*     FileSystem: Automation; */
        Ano: Integer;
        Mes: Integer;
        Dia: Integer;
        Folder: Text[1024];
        Nombre: Text[30];
    begin
        /* fes mig
        DtoLin := 0;
        DtoFact := 0;
        I := 0;
        I1 := 0;
        DtoLinTotal := 0;
        DtoFactTotal := 0;
        Exento := 0;
        
        CLEAR(LinEnvio);
        
        rCodAlmacen.GET(rSIH."Location Code");
        rCodAlmacen.TESTFIELD("Cod. Sucursal");
        
        rConfSant.GET;
        rConfSant.TESTFIELD("Ubicacion XML Respuesta");
        
        rSIH.CALCFIELDS(Amount);
        rSIH.CALCFIELDS("Amount Including VAT");
        
        //Divisa
        IF rSIH."Currency Code" = '' THEN
          BEGIN
            rGLS.GET;
            Moneda := UPPERCASE(rGLS."LCY Code");
            Tasa := 1;
            txtTasa := FORMAT(ROUND(Tasa),0,'<Precision,2:2><Standard format,0>');
          END
        ELSE
          BEGIN
            Moneda := UPPERCASE(rSIH."Currency Code");
            Tasa := (rSIH."Amount Including VAT"/rSIH."Currency Factor");
            Tasa := (Tasa/rSIH."Amount Including VAT");
            txtTasa := FORMAT(ROUND(Tasa),0,'<Precision,2:2><Standard format,0>');
          END;
        //Fin Divisa
        
        //Descuentos
        rSIL.RESET;
        rSIL.SETRANGE("Document No.",rSIH."No.");
        //rSIL.SETRANGE(Type,rSIL.Type::Item);
        rSIL.SETFILTER("No.",'<>%1','');
        IF rSIL.FINDSET THEN
          REPEAT
            I1 += 1;
            ValorDescLin := 0;
            IF rSIL."Line Discount %" <> 0 THEN
              BEGIN
                ValorDescLin :=  ((rSIL."Unit Price") * (rSIL."Line Discount %"))/100;
              END;
        
            IF rSIH."Prices Including VAT" THEN
              DtoLin := rSIL."Line Discount Amount"/(1+rSIL."VAT %"/100)
            ELSE
              DtoLin := rSIL."Line Discount Amount";
        
            IF rSIH."Prices Including VAT" THEN
              DtoFact := rSIL."Inv. Discount Amount"/(1+rSIL."VAT %"/100)
            ELSE
              DtoFact := rSIL."Inv. Discount Amount";
        
            IF rSIH."Prices Including VAT" THEN
              DtoLinTotal += rSIL."Line Discount Amount"/(1+rSIL."VAT %"/100)
            ELSE
              DtoLinTotal += rSIL."Line Discount Amount";
        
            IF rSIH."Prices Including VAT" THEN
              DtoFactTotal += rSIL."Inv. Discount Amount"/(1+rSIL."VAT %"/100)
            ELSE
              DtoFactTotal += rSIL."Inv. Discount Amount";
        
        
            TotalDescuentos := DtoLin + DtoFact;
            txtCant := FORMAT(ROUND(rSIL.Quantity),0,'<Precision,2:2><Standard format,0>');
            IF rSIH."Prices Including VAT" THEN //En caso de que el precio tenga IVA lo quitamos
              txtPrecio := FORMAT((rSIL."Unit Price"/(1+rSIL."VAT %"/100)),0,'<Precision,2:5><Standard format,0>')
            ELSE
              txtPrecio := FORMAT((rSIL."Unit Price"),0,'<Precision,2:5><Standard format,0>');
        
            txtImp := FORMAT(ROUND(rSIL.Amount+TotalDescuentos),0,'<Precision,2:2><Standard format,0>');
        
        
            LinEnvio[I1] :=
           '<LINEA><CANTIDAD>'+txtCant+'</CANTIDAD><DESCRIPCION><![CDATA['+rSIL.Description+']]></DESCRIPCION>'+
           '<METRICA>'+rSIL."Unit of Measure Code"+'</METRICA>'+
           '<PRECIOUNITARIO>'+txtPrecio+'</PRECIOUNITARIO><VALOR>'+txtImp+'</VALOR><DETALLE1>a</DETALLE1></LINEA>';
        
          UNTIL rSIL.NEXT = 0;
        
        txtDtoFact := FORMAT(ROUND(DtoLinTotal + DtoFactTotal),0,'<Precision,2:2><Standard format,0>');
        //Fin Descuentos
        
        //Importes
        txtValorNeto := FORMAT(ROUND(rSIH.Amount),0,'<Precision,2:2><Standard format,0>');
        txtIVA := FORMAT(ROUND(rSIH."Amount Including VAT" - rSIH.Amount),0,'<Precision,2:2><Standard format,0>');
        txtTotal := FORMAT(ROUND(rSIH."Amount Including VAT"-(DtoLinTotal + DtoFactTotal)),0,'<Precision,2:2><Standard format,0>');
        //Fin Importes
        
        
        //Mov. IVA
        rVatEntry.RESET;
        rVatEntry.SETCURRENTKEY("Document No.","Posting Date");
        rVatEntry.SETRANGE(rVatEntry."Document No.",rSIH."No.");
        rVatEntry.SETRANGE(rVatEntry."Posting Date",rSIH."Posting Date");
        rVatEntry.SETRANGE(rVatEntry."Document Type",rVatEntry."Document Type"::Invoice);
        IF rVatEntry.FINDSET THEN
          REPEAT
            IF rVatEntry.Amount = 0 THEN
              BEGIN
                Exento += rVatEntry.Base;
              END;
          UNTIL rVatEntry.NEXT = 0;
        
        txtExento := FORMAT(ROUND(Exento),0,'<Precision,2:2><Standard format,0>');
        //Fin Mov. IVA
        
        //Datos Factura
        I := 0;
        ParteNumerica := '';
        ParteSerie := '';
        Encontrado := FALSE;
        REPEAT
          I += 1;
          IF COPYSTR(rSIH."No. Comprobante Fiscal",I,1) = '-' THEN
            Encontrado := TRUE;
        UNTIL (I = STRLEN(rSIH."No. Comprobante Fiscal")) OR (Encontrado);
        
        NoFact := COPYSTR(rSIH."No. Comprobante Fiscal",I+1,(STRLEN(rSIH."No. Comprobante Fiscal")-(I)));
        Serie := COPYSTR(rSIH."No. Comprobante Fiscal",1,I-1);
        //Fin Datos Cab. Factura
        
        rNoSeriesLine.RESET;
        rNoSeriesLine.SETRANGE("Series Code",rSIH."No. Serie NCF Facturas");
        rNoSeriesLine.SETFILTER("Starting No.",'<=%1',rSIH."No. Comprobante Fiscal");
        rNoSeriesLine.SETFILTER("Ending No.",'>=%1',rSIH."No. Comprobante Fiscal");
        rNoSeriesLine.FINDFIRST;
        
        rNoSeriesLine.TESTFIELD("Tipo Generacion");
        IF rNoSeriesLine."Tipo Generacion" = rNoSeriesLine."Tipo Generacion"::Resguardo THEN
          TG := 'C'
        ELSE
          TG := 'O';
        
        
        //Guardar XML de Respuesta
        Dia := DATE2DMY(WORKDATE,1);
        Mes := DATE2DMY(WORKDATE,2);
        Ano := DATE2DMY(WORKDATE,3);
        
        IF ISCLEAR(FileSystem) THEN
        CREATE(FileSystem);
        
        Folder := rConfSant."Ubicacion XML Respuesta";
        
        IF ISCLEAR(Fiel_ifacere) THEN
          CREATE(Fiel_ifacere);
        
        Fiel_ifacere.RutaApp := Folder;
        
        Fiel_ifacere.ArchivoXML := rSIH."No. Comprobante Fiscal"+'.xml';
        Fiel_ifacere.Produccion := '1';
        Fiel_ifacere.TipoDocumento := 'F';
        
        //Cabecera
        Fiel_ifacere.StringXML := '<FACTURA><ENCABEZADO><NOFACTURA>'+NoFact+'</NOFACTURA><RESOLUCION>';
        Fiel_ifacere.StringXML := rNoSeriesLine."No. Resolucion"+'</RESOLUCION>';
        Fiel_ifacere.StringXML := '<IDSERIE>'+Serie+'</IDSERIE><EMPRESA>'+rConfSant."ID Empresa FE"+'</EMPRESA><SUCURSAL>';
        Fiel_ifacere.StringXML := rCodAlmacen."Cod. Sucursal"+'</SUCURSAL><CAJA>1</CAJA><USUARIO />';
        Fiel_ifacere.StringXML := '<FECHAEMISION>'+FORMAT(rSIH."Posting Date")+'</FECHAEMISION>';
        Fiel_ifacere.StringXML := '<GENERACION>'+TG+'</GENERACION><MONEDA>'+Moneda+'</MONEDA><TASACAMBIO>'+txtTasa+'</TASACAMBIO>';
        Fiel_ifacere.StringXML := '<NOMBRECONTRIBUYENTE><![CDATA['+rSIH."Sell-to Customer Name"+']]></NOMBRECONTRIBUYENTE>';
        Fiel_ifacere.StringXML := '<DIRECCIONCONTRIBUYENTE><![CDATA['+rSIH."Sell-to Address"+']]></DIRECCIONCONTRIBUYENTE>';
        Fiel_ifacere.StringXML := '<NITCONTRIBUYENTE>'+rSIH."VAT Registration No."+'</NITCONTRIBUYENTE><VALORNETO>';
        Fiel_ifacere.StringXML := txtValorNeto+'</VALORNETO><IVA>'+txtIVA+'</IVA><TOTAL>'+txtTotal+'<';
        Fiel_ifacere.StringXML := '/TOTAL><DESCUENTO>'+txtDtoFact+'</DESCUENTO><EXENTO>0</EXENTO></ENCABEZADO>';
        Fiel_ifacere.StringXML := '<OPCIONAL><OPCIONAL1 /><OPCIONAL2>';
        Fiel_ifacere.StringXML := '</OPCIONAL2><OPCIONAL3></OPCIONAL3><OPCIONAL4></OPCIONAL4><OPCIONAL5></OPCIONAL5><OPCIONAL6>';
        Fiel_ifacere.StringXML := '</OPCIONAL6></OPCIONAL><DETALLE>';
        
        k:=0;
        REPEAT
         k+=1;
         Fiel_ifacere.StringXML := LinEnvio[k];
        
        UNTIL k = I1;
        
        //Lineas
        
        Fiel_ifacere.StringXML := '</DETALLE></FACTURA>';
        
        Fiel_ifacere.EjecutaWebService;
        
        IF Fiel_ifacere.Mensaje = '' THEN
          BEGIN
            IF Fiel_ifacere.pResultado = 'True' THEN
              BEGIN
                IF Fiel_ifacere.pCAE <> '' THEN
                  rSIH.CAE := Fiel_ifacere.pCAE
                ELSE
                  rSIH.CAEC := Fiel_ifacere.pCAEC;
        
                rSIH."Respuesta CAE/CAEC" := COPYSTR(Fiel_ifacere.pDescripcion,1,100);
                rSIH.pIdSat := Fiel_ifacere.pIdSat;
                rSIH."No. Resolucion" := rNoSeriesLine."No. Resolucion";
                rSIH."Fecha Resolucion" := rNoSeriesLine."Fecha Resolucion";
                rSIH."Serie Desde" := rNoSeriesLine."Starting No.";
                rSIH."Serie hasta" := rNoSeriesLine."Ending No.";
                rSIH."Serie Resolucion" := Serie;
                rSIH.MODIFY;
              END
            ELSE
              BEGIN
                IF GUIALLOWED THEN
                  BEGIN
                    MESSAGE(COPYSTR(Fiel_ifacere.pDescripcion,1,100));
                    MESSAGE(Text003);
                  END;
              END;
          END
        ELSE
          IF GUIALLOWED THEN
            MESSAGE(txt0001);
        
        CLEAR(Fiel_ifacere);
        COMMIT;
        fes mig*/

    end;


    procedure ValResp_Fact(NoFact: Code[20]; var txtResp: array[7] of Text[1024]): Boolean
    var
/*         xmlNodeList1: Automation;
        xmlNodeList2: Automation;
        xmlNodeList3: Automation;
        xmldomElem1: Automation;
        xmldomElem2: Automation;
        xmldomElem3: Automation;
        xmldomAttrib: Automation; */
        fFile: File;
        strInStream: InStream;
        I: Integer;
        CantElem: Integer;
        Folder: Text[1024];
        Ano: Integer;
        Mes: Integer;
        Dia: Integer;
        rSIH: Record "Sales Invoice Header";
    begin
        /* fes mig
        Dia := DATE2DMY(WORKDATE,1);
        Mes := DATE2DMY(WORKDATE,2);
        Ano := DATE2DMY(WORKDATE,3);
        
        
        //Folder := rXMLFact."Ubicacion XML Respuesta"+'\'+FORMAT(Ano)+'\'+FORMAT(Mes)+'\'+FORMAT(Dia)+'\'+NoFact+'.xml';
        
        fFile.OPEN(Folder);
        fFile.CREATEINSTREAM(strInStream);
        
        IF ISCLEAR(xmldomDoc) THEN CREATE(xmldomDoc);
        
        xmldomDoc.load(strInStream);
        
        xmlNodeList1 := xmldomDoc.getElementsByTagName('RegistraFacturaResult');
        
        FOR I:=0 TO xmlNodeList1.length() DO
          BEGIN
            xmldomElem1:= xmlNodeList1.item(I); //RegistraFacturaResult
            IF xmldomElem1.hasChildNodes() THEN
              BEGIN
                xmlNodeList3:= xmldomElem1.childNodes();
                IF NOT ISCLEAR(xmlNodeList3) THEN
                 xmldomElem3:= xmldomElem1.firstChild();
        
                IF NOT ISCLEAR(xmldomElem3) THEN
                  txtResp[1]:=xmldomElem3.text();
                CantElem := xmlNodeList3.length();
        
                FOR I := 1 TO CantElem - 1 DO
                  BEGIN
                    xmldomElem3:=xmlNodeList3.item(I);
                    IF NOT ISCLEAR(xmldomElem3) THEN
                      txtResp[I+1]:=xmldomElem3.text();
                  END;
              END;
          END;
        
        fFile.CLOSE;
        CLEARALL;
        
        rSIH.RESET;
        rSIH.SETCURRENTKEY(rSIH."No. Comprobante Fiscal");
        rSIH.SETRANGE(rSIH."No. Comprobante Fiscal",NoFact);
        IF rSIH.FINDFIRST THEN;
        
        IF txtResp[1] = 'true' THEN
          BEGIN
            rSIH.CAE := txtResp[5];
            rSIH."Respuesta CAE/CAEC" := txtResp[2];
            rSIH.pIdSat := txtResp[3];
            rSIH.MODIFY;
            EXIT(TRUE);
          END
        ELSE
          BEGIN
            rSIH."Respuesta CAE/CAEC" := txtResp[2];
            rSIH.MODIFY;
            EXIT(FALSE);
          END;
        fes mig */

    end;


    procedure CreaXML(rSIH: Record "Sales Invoice Header")
    var
/*         CurrNode: Automation;
        CurrNode1: Automation;
        CurrNode2: Automation;
        NewChild: Automation;
        xmlProcessingInst: Automation;
        xmlMgt: Codeunit "XML DOM Management";
        rSIL: Record "Sales Invoice Line"; */
    begin
        /* fes mig
        rConfSant.GET;
        rCodAlmacen.GET(rSIH."Location Code");
        rCodAlmacen.TESTFIELD("Cod. Sucursal");
        
        rSIH.CALCFIELDS(Amount);
        rSIH.CALCFIELDS("Amount Including VAT");
        
        
        //Divisa
        IF rSIH."Currency Code" = '' THEN
          BEGIN
            rGLS.GET;
            Moneda := UPPERCASE(rGLS."LCY Code");
            Tasa := 1;
            txtTasa := FORMAT(ROUND(Tasa),0,'<Precision,2:2><Standard format,0>');
          END
        ELSE
          BEGIN
            Moneda := UPPERCASE(rSIH."Currency Code");
            Tasa := (rSIH."Amount Including VAT"/rSIH."Currency Factor");
            Tasa := (Tasa/rSIH."Amount Including VAT");
            txtTasa := FORMAT(ROUND(Tasa),0,'<Precision,2:2><Standard format,0>');
          END;
        //Fin Divisa
        
        //Lineas de la factura
        DtoLin := 0;
        DtoFact := 0;
        
        rSIL.RESET;
        rSIL.SETRANGE("Document No.",rSIH."No.");
        //rSIL.SETRANGE(Type,rSIL.Type::Item);
        rSIL.SETFILTER("No.",'<>%1','');
        IF rSIL.FINDSET THEN
          REPEAT
            I += 1;
            DtoLin += rSIL."Line Discount Amount";
            DtoFact += rSIL."Inv. Discount Amount";
          UNTIL rSIL.NEXT = 0;
        
        TotalDescuentos := DtoLin + DtoFact;
        
        //Importes
        txtValorNeto := FORMAT(ROUND(rSIH.Amount),0,'<Precision,2:2><Standard format,0>');
        txtIVA := FORMAT(ROUND(rSIH."Amount Including VAT" - rSIH.Amount),0,'<Precision,2:2><Standard format,0>');
        txtTotal := FORMAT(ROUND(rSIH."Amount Including VAT"-TotalDescuentos),0,'<Precision,2:2><Standard format,0>');
        //Fin Importes
        
        //Mov. IVA
        Exento := 0;
        rVatEntry.RESET;
        rVatEntry.SETCURRENTKEY("Document No.","Posting Date");
        rVatEntry.SETRANGE(rVatEntry."Document No.",rSIH."No.");
        rVatEntry.SETRANGE(rVatEntry."Posting Date",rSIH."Posting Date");
        rVatEntry.SETRANGE(rVatEntry."Document Type",rVatEntry."Document Type"::Invoice);
        IF rVatEntry.FINDSET THEN
          REPEAT
            IF rVatEntry.Amount = 0 THEN
              BEGIN
                Exento += rVatEntry.Base;
              END;
          UNTIL rVatEntry.NEXT = 0;
        
        txtExento := FORMAT(ROUND(Exento),0,'<Precision,2:2><Standard format,0>');
        //Fin Mov. IVA
        
        
        
        //Datos Factura
        NoFact := rSIH."No. Comprobante Fiscal";
        NoFact := DELCHR(NoFact,'=','ABCDEFGHIJKLMNOPQRSTWXYZ-');
        //Fin Datos Cab. Factura
        
        
        CREATE(xmlDoc);
        xmlMgt.SetNormalCase;
        xmlProcessingInst:=xmlDoc.createProcessingInstruction('xml','version="1.0" encoding="ISO-8859-1" standalone="yes"');
        
        CurrNode := xmlDoc.appendChild(xmlProcessingInst);
        CurrNode := xmlDoc.createElement('soapenv:Envelope');
        CurrNode := xmlDoc.appendChild(CurrNode);
        
        
        xmlMgt.AddAttribute(CurrNode,'xmlns:xsi','http://www.w3.org/2001/XMLSchema-instance');
        xmlMgt.AddAttribute(CurrNode,'xmlns:xsd','http://www.w3.org/2001/XMLSchema');
        xmlMgt.AddAttribute(CurrNode,'xmlns:soapenv','http://schemas.xmlsoap.org/soap/envelope/');
        
        
        xmlMgt.AddElement(CurrNode,'soap:Body','','soapenv',NewChild);
        CurrNode:=NewChild; //one level deeper
        xmlMgt.AddElement(CurrNode,'RegistraFactura','','http://www.megaprint.com.gt/WebService',NewChild);
        
        
        CurrNode:=NewChild; //one level deeper
        xmlMgt.AddElement(CurrNode,'PXMLFactura','','',NewChild);
        CurrNode:=NewChild; //one level deeper
        xmlMgt.AddElement(CurrNode,'FACTURA','','',NewChild);
        
        CurrNode1:=NewChild;//one level deeper
        xmlMgt.AddElement(CurrNode1,'ENCABEZADO','','',NewChild);
        
        
        {
        CurrNode2:=NewChild; //one level deeper
        xmlMgt.AddElement(CurrNode2,'NOFACTURA',NoFact,'',NewChild);
        xmlMgt.AddElement(CurrNode2,'RESOLUCION',rXMLFact."No. Resolucion",'',NewChild);
        xmlMgt.AddElement(CurrNode2,'IDSERIE','G','',NewChild);
        xmlMgt.AddElement(CurrNode2,'EMPRESA',rConfSant."ID Empresa FE",'',NewChild);
        xmlMgt.AddElement(CurrNode2,'SUCURSAL',rCodAlmacen."Cod. Sucursal",'',NewChild);
        xmlMgt.AddElement(CurrNode2,'CAJA','1','',NewChild);
        xmlMgt.AddElement(CurrNode2,'USUARIO','','',NewChild);
        xmlMgt.AddElement(CurrNode2,'FECHAEMISION',FORMAT(rSIH."Posting Date"),'',NewChild);
        xmlMgt.AddElement(CurrNode2,'GENERACION','0','',NewChild);
        xmlMgt.AddElement(CurrNode2,'MONEDA',Moneda,'',NewChild);
        xmlMgt.AddElement(CurrNode2,'TASACAMBIO',txtTasa,'',NewChild);
        xmlMgt.AddElement(CurrNode2,'NOMBRECONTRIBUYENTE',rSIH."Sell-to Customer Name",'',NewChild);
        xmlMgt.AddElement(CurrNode2,'DIRECCIONCONTRIBUYENTE',rSIH."Sell-to Address",'',NewChild);
        xmlMgt.AddElement(CurrNode2,'NITCONTRIBUYENTE',rSIH."VAT Registration No.",'',NewChild);
        xmlMgt.AddElement(CurrNode2,'VALORNETO',txtValorNeto,'',NewChild);
        xmlMgt.AddElement(CurrNode2,'IVA',txtIVA,'',NewChild);
        xmlMgt.AddElement(CurrNode2,'TOTAL',txtTotal,'',NewChild);
        xmlMgt.AddElement(CurrNode2,'DESCUENTO',txtDtoFact,'',NewChild);
        xmlMgt.AddElement(CurrNode2,'EXENTO',txtExento,'',NewChild);
        }
        xmlMgt.AddElement(CurrNode1,'OPCIONAL','','',NewChild);
        
        CurrNode2:=NewChild; //One level deeper to sublevel
        xmlMgt.AddElement(CurrNode2,'OPCIONAL1','','',NewChild);
        xmlMgt.AddElement(CurrNode2,'OPCIONAL2','','',NewChild);
        xmlMgt.AddElement(CurrNode2,'OPCIONAL3','','',NewChild);
        xmlMgt.AddElement(CurrNode2,'OPCIONAL4','','',NewChild);
        xmlMgt.AddElement(CurrNode2,'OPCIONAL5','','',NewChild);
        xmlMgt.AddElement(CurrNode2,'OPCIONAL6','','',NewChild);
        
        xmlMgt.AddElement(CurrNode1,'DETALLE','','',NewChild);
        
        //Lineas de la factura
        rSIL.RESET;
        rSIL.SETRANGE("Document No.",rSIH."No.");
        //rSIL.SETRANGE(Type,rSIL.Type::Item);
        rSIL.SETFILTER("No.",'<>%1','');
        IF rSIL.FINDSET THEN
          REPEAT
            I += 1;
            DtoLin += rSIL."Line Discount Amount";
            DtoFact += rSIL."Inv. Discount Amount";
            txtCant := FORMAT(ROUND(rSIL.Quantity),0,'<Precision,2:2><Standard format,0>');
            txtPrecio := FORMAT(ROUND(rSIL."Amount Including VAT"/rSIL.Quantity),0,'<Precision,2:2><Standard format,0>');
            txtImp := FORMAT(ROUND(rSIL."Amount Including VAT"),0,'<Precision,2:2><Standard format,0>');
        
        
            LinEnvio[I] :=
           '<LINEA><CANTIDAD>'+txtCant+'</CANTIDAD><DESCRIPCION>'+'P'+'</DESCRIPCION>'+
           '<METRICA>'+rSIL."Unit of Measure Code"+'</METRICA>'+
           '<PRECIOUNITARIO>'+txtPrecio+'</PRECIOUNITARIO><VALOR>'+txtImp+'</VALOR><DETALLE1>'+rSIL."No."+'</DETALLE1></LINEA>';
        
          UNTIL rSIL.NEXT = 0;
        
        txtDtoFact := FORMAT(ROUND(DtoLin + DtoFact),0,'<Precision,2:2><Standard format,0>');
        
        
        {
        
                             recCustomer.SETRANGE("No.", 'CTE-000001','CTE-000002'); //Filter only few records
                             IF recCustomer.FINDFIRST THEN BEGIN
                               REPEAT
                                vName   :=recCustomer.Name;
                                vNo     :=recCustomer."No.";
                                vContact:=recCustomer.Contact;
                                  recCustomer.CALCFIELDS("Balance (LCY)");
                                  vBalance:= FORMAT(recCustomer."Balance (LCY)");
                                vSPcode :=recCustomer."Salesperson Code";
        
        
                                xmlMgt.AddElement(CurrNode,'mbs:Customer','','mbs',NewChild);
                                      CurrNode1:=NewChild; //One level deeper, but keep current level too
                                      xmlMgt.AddElement(CurrNode1,'mbs:CustomerAuthentication','','mbs',NewChild);
                                             CurrNode2:=NewChild; //One level deeper to sublevel
                                             xmlMgt.AddElement(CurrNode2,'mbs:No',vNo,'mbs',NewChild);
                                             xmlMgt.AddElement(CurrNode2,'mbs:Name',vName,'mbs',NewChild);
        
                                      xmlMgt.AddElement(CurrNode1,'mbs:CustomerData','','mbs',NewChild);
                                             CurrNode2:=NewChild; //One level deeper to sublevel
                                             xmlMgt.AddElement(CurrNode2,'mbs:Balance',vBalance,'mbs',NewChild);
                                             xmlMgt.AddElement(CurrNode2,'mbs:SalespersonCode',vSPcode,'mbs',NewChild);
                                             xmlMgt.AddElement(CurrNode2,'mbs:Contacts','','mbs',NewChild);
                                                 CurrNode1:=NewChild;//One level deeper
                                                 xmlMgt.AddElement(CurrNode1,'mbs:Contact',vContact,'mbs',NewChild);
        
                                CLEAR(vName);
                                CLEAR(vNo)  ;
                                CLEAR(vContact);
                                CLEAR(vBalance);
                                CLEAR(vSPcode);
        
                               UNTIL recCustomer.NEXT=0;
        
        }
        
        
                               xmlDoc.save('C:\Clientes\xmlFile.xml');
                               HYPERLINK('C:\Clientes\xmlFile.xml');
                               CLEARALL;
                               MESSAGE('xmlFile.xml is created');
                            // END;
        fes mig */

    end;


    procedure NotaCR(rSCMH: Record "Sales Cr.Memo Header")
    var
        rSCML: Record "Sales Cr.Memo Line";
      /*   FileSystem: Automation; */
        Ano: Integer;
        Mes: Integer;
        Dia: Integer;
        Folder: Text[1024];
        Nombre: Text[30];
        rSIH: Record "Sales Invoice Header";
    begin
        /* fes mig
        rSCMH.TESTFIELD("No. Comprobante Fiscal Rel.");
        DtoLin := 0;
        DtoFact := 0;
        I := 0;
        I1 := 0;
        CLEAR(LinEnvio);
        
        rCodAlmacen.GET(rSCMH."Location Code");
        rCodAlmacen.TESTFIELD("Cod. Sucursal");
        
        rConfSant.GET;
        rConfSant.TESTFIELD("Ubicacion XML Respuesta");
        
        rSCMH.CALCFIELDS(Amount);
        rSCMH.CALCFIELDS("Amount Including VAT");
        
        //Divisa
        IF rSCMH."Currency Code" = '' THEN
          BEGIN
            rGLS.GET;
            Moneda := UPPERCASE(rGLS."LCY Code");
            Tasa := 1;
            txtTasa := FORMAT(ROUND(Tasa),0,'<Precision,2:2><Standard format,0>');
          END
        ELSE
          BEGIN
            Moneda := UPPERCASE(rSCMH."Currency Code");
            Tasa := (rSCMH."Amount Including VAT"/rSCMH."Currency Factor");
            Tasa := (Tasa/rSCMH."Amount Including VAT");
            txtTasa := FORMAT(ROUND(Tasa),0,'<Precision,2:2><Standard format,0>');
          END;
        //Fin Divisa
        
        //Descuentos
        rSCML.RESET;
        rSCML.SETRANGE("Document No.",rSCMH."No.");
        rSCML.SETFILTER("No.",'<>%1','');
        IF rSCML.FINDSET THEN
          REPEAT
            I1 += 1;
        
            IF rSCMH."Prices Including VAT" THEN
              DtoLin := rSCML."Line Discount Amount"/(1+rSCML."VAT %"/100)
            ELSE
              DtoLin := rSCML."Line Discount Amount";
        
        
            IF rSCMH."Prices Including VAT" THEN
              DtoFact := rSCML."Inv. Discount Amount"/(1+rSCML."VAT %"/100)
            ELSE
              DtoFact := rSCML."Inv. Discount Amount";
        
            IF rSCMH."Prices Including VAT" THEN
              DtoLinTotal += rSCML."Line Discount Amount"/(1+rSCML."VAT %"/100)
            ELSE
              DtoLinTotal += rSCML."Line Discount Amount";
        
        
            IF rSCMH."Prices Including VAT" THEN
              DtoFactTotal += rSCML."Inv. Discount Amount"/(1+rSCML."VAT %"/100)
            ELSE
              DtoFactTotal += rSCML."Inv. Discount Amount";
        
        
            TotalDescuentos := DtoLin + DtoFact;
            txtCant := FORMAT(ROUND(rSCML.Quantity),0,'<Precision,2:2><Standard format,0>');
            IF rSCMH."Prices Including VAT" THEN
              txtPrecio := FORMAT((rSCML."Unit Price"/(1+rSCML."VAT %"/100)),0,'<Precision,2:5><Standard format,0>')
            ELSE
              txtPrecio := FORMAT(rSCML."Unit Price",0,'<Precision,2:5><Standard format,0>');
        
            txtImp := FORMAT(ROUND(rSCML.Amount+TotalDescuentos),0,'<Precision,2:2><Standard format,0>');
        
            LinEnvio[I1] :=
           '<LINEA><CANTIDAD>'+txtCant+'</CANTIDAD><DESCRIPCION>'+'<![CDATA['+rSCML.Description+']]></DESCRIPCION>'+
           '<METRICA>'+rSCML."Unit of Measure Code"+'</METRICA>'+
           '<PRECIOUNITARIO>'+txtPrecio+'</PRECIOUNITARIO><VALOR>'+txtImp+'</VALOR><DETALLE1>'+
           '<![CDATA['+rSCML."No."+']]></DETALLE1></LINEA>';
          UNTIL rSCML.NEXT = 0;
        
        txtDtoFact := FORMAT(ROUND(DtoLinTotal + DtoFactTotal),0,'<Precision,2:2><Standard format,0>');
        //Fin Descuentos
        
        //Importes
        txtValorNeto := FORMAT(ROUND(rSCMH.Amount),0,'<Precision,2:2><Standard format,0>');
        txtIVA := FORMAT(ROUND(rSCMH."Amount Including VAT" - rSCMH.Amount),0,'<Precision,2:2><Standard format,0>');
        txtTotal := FORMAT(ROUND(rSCMH."Amount Including VAT"-(DtoLinTotal + DtoFactTotal)),0,'<Precision,2:2><Standard format,0>');
        //Fin Importes
        
        //Mov. IVA
        rVatEntry.RESET;
        rVatEntry.SETCURRENTKEY("Document No.","Posting Date");
        rVatEntry.SETRANGE(rVatEntry."Document No.",rSCMH."No.");
        rVatEntry.SETRANGE(rVatEntry."Posting Date",rSCMH."Posting Date");
        rVatEntry.SETRANGE(rVatEntry."Document Type",rVatEntry."Document Type"::Invoice);
        IF rVatEntry.FINDSET THEN
          REPEAT
            IF rVatEntry.Amount = 0 THEN
              BEGIN
                Exento += rVatEntry.Base;
              END;
          UNTIL rVatEntry.NEXT = 0;
        
        txtExento := FORMAT(ROUND(Exento),0,'<Precision,2:2><Standard format,0>');
        //Fin Mov. IVA
        
        //Datos Factura
        I := 0;
        ParteNumerica := '';
        ParteSerie := '';
        Encontrado := FALSE;
        REPEAT
          I += 1;
          IF COPYSTR(rSCMH."No. Comprobante Fiscal",I,1) = '-' THEN
            Encontrado := TRUE;
        UNTIL (I = STRLEN(rSCMH."No. Comprobante Fiscal")) OR (Encontrado);
        
        NoFact := COPYSTR(rSCMH."No. Comprobante Fiscal",I+1,(STRLEN(rSCMH."No. Comprobante Fiscal")-(I)));
        Serie := COPYSTR(rSCMH."No. Comprobante Fiscal",1,I-1);
        //Fin Datos Cab. Factura
        
        //Para No. Comp. Relacionado
        I := 0;
        ParteNumerica := '';
        ParteSerie := '';
        Encontrado := FALSE;
        REPEAT
          I += 1;
          IF COPYSTR(rSCMH."No. Comprobante Fiscal Rel.",I,1) = '-' THEN
            Encontrado := TRUE;
        UNTIL (I = STRLEN(rSCMH."No. Comprobante Fiscal Rel.")) OR (Encontrado);
        
        NoFactRel := COPYSTR(rSCMH."No. Comprobante Fiscal Rel.",I+1,(STRLEN(rSCMH."No. Comprobante Fiscal Rel.")-(I)));
        SerieRel := COPYSTR(rSCMH."No. Comprobante Fiscal Rel.",1,I-1);
        //Para No. Comp. Relacionado
        
        
        rNoSeriesLine.RESET;
        rNoSeriesLine.SETRANGE("Series Code",rSCMH."No. Serie NCF Abonos");
        //rNoSeriesLine.SETRANGE(Open,TRUE);
        rNoSeriesLine.SETFILTER("Starting No.",'<=%1',rSCMH."No. Comprobante Fiscal");
        rNoSeriesLine.SETFILTER("Ending No.",'>=%1',rSCMH."No. Comprobante Fiscal");
        rNoSeriesLine.FINDFIRST;
        
        rNoSeriesLine.TESTFIELD("Tipo Generacion");
        IF rNoSeriesLine."Tipo Generacion" = rNoSeriesLine."Tipo Generacion"::Resguardo THEN
          TG := 'C'
        ELSE
          TG := 'O';
        
        
        Folder := rConfSant."Ubicacion XML Respuesta";
        
        IF ISCLEAR(Fiel_ifacere) THEN
          CREATE(Fiel_ifacere);
        
        Fiel_ifacere.RutaApp := Folder;
        
        Fiel_ifacere.ArchivoXML := rSCMH."No. Comprobante Fiscal"+'.xml';
        
        Fiel_ifacere.Produccion := '1';
        Fiel_ifacere.TipoDocumento := 'N';
        
        IF NOT rSIH.GET(rSCMH."Applies-to Doc. No.") THEN
          BEGIN
            rSIH.RESET;
            rSIH.SETCURRENTKEY(rSIH."No. Comprobante Fiscal");
            rSIH.SETRANGE(rSIH."No. Comprobante Fiscal",rSCMH."No. Comprobante Fiscal Rel.");
            rSIH.FINDFIRST;
          END;
        
        IF rSCMH."Pre-Assigned No." <> '' THEN
          Concepto := 'ANULACION'
        ELSE
          Concepto := 'DEVOLUCION';
        
        
        //Cabecera
        Fiel_ifacere.StringXML := '<NOTACREDITO><ENCABEZADO><NODOCUMENTO>'+NoFact+'</NODOCUMENTO><RESOLUCION>';
        Fiel_ifacere.StringXML := rNoSeriesLine."No. Resolucion"+'</RESOLUCION>';
        Fiel_ifacere.StringXML := '<IDSERIE>'+Serie+'</IDSERIE><EMPRESA>'+rConfSant."ID Empresa FE"+'</EMPRESA><SUCURSAL>';
        Fiel_ifacere.StringXML := rCodAlmacen."Cod. Sucursal"+'</SUCURSAL><CAJA>1</CAJA><USUARIO />';
        Fiel_ifacere.StringXML := '<FECHAEMISION>'+FORMAT(rSCMH."Posting Date")+'</FECHAEMISION>';
        Fiel_ifacere.StringXML := '<GENERACION>'+TG+'</GENERACION><MONEDA>'+Moneda+'</MONEDA><TASACAMBIO>'+txtTasa+'</TASACAMBIO>';
        Fiel_ifacere.StringXML := '<NOMBRECONTRIBUYENTE><![CDATA['+rSCMH."Sell-to Customer Name"+']]></NOMBRECONTRIBUYENTE>';
        Fiel_ifacere.StringXML := '<DIRECCIONCONTRIBUYENTE><![CDATA['+rSCMH."Sell-to Address"+']]></DIRECCIONCONTRIBUYENTE>';
        Fiel_ifacere.StringXML := '<NITCONTRIBUYENTE>'+rSCMH."VAT Registration No."+'</NITCONTRIBUYENTE><VALORNETO>';
        Fiel_ifacere.StringXML := txtValorNeto+'</VALORNETO><IVA>'+txtIVA+'</IVA><TOTAL>'+txtTotal+'<';
        Fiel_ifacere.StringXML := '/TOTAL><DESCUENTO>'+txtDtoFact+'</DESCUENTO>';
        Fiel_ifacere.StringXML := '<NOFACTURA>'+NoFactRel+'</NOFACTURA>';
        Fiel_ifacere.StringXML := '<SERIEFACTURA>'+SerieRel+'</SERIEFACTURA>';
        Fiel_ifacere.StringXML := '<FECHAFACTURA>'+FORMAT(rSIH."Posting Date")+'</FECHAFACTURA>';
        Fiel_ifacere.StringXML := '<CONCEPTO>'+Concepto+'</CONCEPTO>';
        Fiel_ifacere.StringXML := '</ENCABEZADO>';
        Fiel_ifacere.StringXML := '<OPCIONAL></OPCIONAL>';
        Fiel_ifacere.StringXML := '<DETALLE>';
        
        k:=0;
        REPEAT
         k+=1;
         Fiel_ifacere.StringXML := LinEnvio[k];
        
        UNTIL k = I1;
        
        //Lineas
        
        Fiel_ifacere.StringXML := '</DETALLE></NOTACREDITO>';
        
        Fiel_ifacere.EjecutaWebService;
        
        
        IF Fiel_ifacere.pResultado = 'True' THEN
          BEGIN
            rNoSeriesLine.RESET;
            rNoSeriesLine.SETRANGE("Series Code",rSCMH."No. Serie NCF Abonos");
            rNoSeriesLine.SETRANGE(Open,TRUE);
            rNoSeriesLine.FINDFIRST;
        
            rSCMH.CAE := Fiel_ifacere.pCAE;
            rSCMH.CAEC := Fiel_ifacere.pCAEC;
            rSCMH."Respuesta CAE" := COPYSTR(Fiel_ifacere.pDescripcion,1,100);
            rSCMH.pIdSat := Fiel_ifacere.pIdSat;
            rSCMH."No. Resolucion" := rNoSeriesLine."No. Resolucion";
            rSCMH."Fecha Resolucion" := rNoSeriesLine."Fecha Resolucion";
            rSCMH."Serie Desde" := rNoSeriesLine."Starting No.";
            rSCMH."Serie hasta" := rNoSeriesLine."Ending No.";
            rSCMH."Serie Resolucion" := Serie;
            rSCMH.MODIFY;
          END
        ELSE
          MESSAGE(Text003);
        
        CLEAR(Fiel_ifacere);
        COMMIT;
        fes mig */

    end;


    procedure AnulaFactura(rSIH: Record "Sales Invoice Header")
    var
        rSIL: Record "Sales Invoice Line";
      /*   FileSystem: Automation; */
        Ano: Integer;
        Mes: Integer;
        Dia: Integer;
        Folder: Text[1024];
        Nombre: Text[30];
    begin
        /* fes mig
        DtoLin := 0;
        DtoFact := 0;
        I := 0;
        I1 := 0;
        DtoLinTotal := 0;
        DtoFactTotal := 0;
        Exento := 0;
        
        {
        IF (rSIH.CAE = '') AND (rSIH.CAEC = '') THEN
          ERROR(Error001);
        
        rSIH.TESTFIELD("Sello Digital Anulado",FALSE);
        }
        CLEAR(LinEnvio);
        
        
        rCodAlmacen.GET(rSIH."Location Code");
        rCodAlmacen.TESTFIELD("Cod. Sucursal");
        
        rConfSant.GET;
        rConfSant.TESTFIELD("Ubicacion XML Respuesta");
        
        rSIH.CALCFIELDS(Amount);
        rSIH.CALCFIELDS("Amount Including VAT");
        
        //Divisa
        IF rSIH."Currency Code" = '' THEN
          BEGIN
            rGLS.GET;
            Moneda := UPPERCASE(rGLS."LCY Code");
            Tasa := 1;
            txtTasa := FORMAT(ROUND(Tasa),0,'<Precision,2:2><Standard format,0>');
          END
        ELSE
          BEGIN
            Moneda := UPPERCASE(rSIH."Currency Code");
            Tasa := (rSIH."Amount Including VAT"/rSIH."Currency Factor");
            Tasa := (Tasa/rSIH."Amount Including VAT");
            txtTasa := FORMAT(ROUND(Tasa),0,'<Precision,2:2><Standard format,0>');
          END;
        //Fin Divisa
        
        //Descuentos
        rSIL.RESET;
        rSIL.SETRANGE("Document No.",rSIH."No.");
        //rSIL.SETRANGE(Type,rSIL.Type::Item);
        rSIL.SETFILTER("No.",'<>%1','');
        IF rSIL.FINDSET THEN
          REPEAT
            I1 += 1;
            ValorDescLin := 0;
            IF rSIL."Line Discount %" <> 0 THEN
              BEGIN
                ValorDescLin :=  ((rSIL."Unit Price") * (rSIL."Line Discount %"))/100;
              END;
        
            IF rSIH."Prices Including VAT" THEN
              DtoLin := rSIL."Line Discount Amount"/(1+rSIL."VAT %"/100)
            ELSE
              DtoLin := rSIL."Line Discount Amount";
        
            IF rSIH."Prices Including VAT" THEN
              DtoFact := rSIL."Inv. Discount Amount"/(1+rSIL."VAT %"/100)
            ELSE
              DtoFact := rSIL."Inv. Discount Amount";
        
            IF rSIH."Prices Including VAT" THEN
              DtoLinTotal += rSIL."Line Discount Amount"/(1+rSIL."VAT %"/100)
            ELSE
              DtoLinTotal += rSIL."Line Discount Amount";
        
            IF rSIH."Prices Including VAT" THEN
              DtoFactTotal += rSIL."Inv. Discount Amount"/(1+rSIL."VAT %"/100)
            ELSE
              DtoFactTotal += rSIL."Inv. Discount Amount";
        
        
            TotalDescuentos := DtoLin + DtoFact;
            txtCant := FORMAT(ROUND(rSIL.Quantity),0,'<Precision,2:2><Standard format,0>');
            IF rSIH."Prices Including VAT" THEN //En caso de que el precio tenga IVA lo quitamos
              txtPrecio := FORMAT((rSIL."Unit Price"/(1+rSIL."VAT %"/100)),0,'<Precision,2:5><Standard format,0>')
            ELSE
              txtPrecio := FORMAT((rSIL."Unit Price"),0,'<Precision,2:5><Standard format,0>');
        
            txtImp := FORMAT(ROUND(rSIL.Amount+TotalDescuentos),0,'<Precision,2:2><Standard format,0>');
        
        
            LinEnvio[I1] :=
           '<LINEA><CANTIDAD>'+txtCant+'</CANTIDAD><DESCRIPCION><![CDATA['+rSIL.Description+']]></DESCRIPCION>'+
           '<METRICA>'+rSIL."Unit of Measure Code"+'</METRICA>'+
           '<PRECIOUNITARIO>'+txtPrecio+'</PRECIOUNITARIO><VALOR>'+txtImp+'</VALOR><DETALLE1>a</DETALLE1></LINEA>';
        
          UNTIL rSIL.NEXT = 0;
        
        txtDtoFact := FORMAT(ROUND(DtoLinTotal + DtoFactTotal),0,'<Precision,2:2><Standard format,0>');
        //Fin Descuentos
        
        //Importes
        txtValorNeto := FORMAT(ROUND(rSIH.Amount),0,'<Precision,2:2><Standard format,0>');
        txtIVA := FORMAT(ROUND(rSIH."Amount Including VAT" - rSIH.Amount),0,'<Precision,2:2><Standard format,0>');
        txtTotal := FORMAT(ROUND(rSIH."Amount Including VAT"-(DtoLinTotal + DtoFactTotal)),0,'<Precision,2:2><Standard format,0>');
        //Fin Importes
        
        
        //Mov. IVA
        rVatEntry.RESET;
        rVatEntry.SETCURRENTKEY("Document No.","Posting Date");
        rVatEntry.SETRANGE(rVatEntry."Document No.",rSIH."No.");
        rVatEntry.SETRANGE(rVatEntry."Posting Date",rSIH."Posting Date");
        rVatEntry.SETRANGE(rVatEntry."Document Type",rVatEntry."Document Type"::Invoice);
        IF rVatEntry.FINDSET THEN
          REPEAT
            IF rVatEntry.Amount = 0 THEN
              BEGIN
                Exento += rVatEntry.Base;
              END;
          UNTIL rVatEntry.NEXT = 0;
        
        txtExento := FORMAT(ROUND(Exento),0,'<Precision,2:2><Standard format,0>');
        //Fin Mov. IVA
        
        //Datos Factura
        I := 0;
        ParteNumerica := '';
        ParteSerie := '';
        Encontrado := FALSE;
        REPEAT
          I += 1;
          IF COPYSTR(rSIH."No. Comprobante Fiscal",I,1) = '-' THEN
            Encontrado := TRUE;
        UNTIL (I = STRLEN(rSIH."No. Comprobante Fiscal")) OR (Encontrado);
        
        NoFact := COPYSTR(rSIH."No. Comprobante Fiscal",I+1,(STRLEN(rSIH."No. Comprobante Fiscal")-(I)));
        Serie := COPYSTR(rSIH."No. Comprobante Fiscal",1,I-1);
        //Fin Datos Cab. Factura
        
        rNoSeriesLine.RESET;
        rNoSeriesLine.SETRANGE("Series Code",rSIH."No. Serie NCF Facturas");
        rNoSeriesLine.SETFILTER("Starting No.",'<=%1',rSIH."No. Comprobante Fiscal");
        rNoSeriesLine.SETFILTER("Ending No.",'>=%1',rSIH."No. Comprobante Fiscal");
        rNoSeriesLine.FINDFIRST;
        
        rNoSeriesLine.TESTFIELD("Tipo Generacion");
        IF rNoSeriesLine."Tipo Generacion" = rNoSeriesLine."Tipo Generacion"::Resguardo THEN
          TG := 'C'
        ELSE
          TG := 'O';
        
        
        //Guardar XML de Respuesta
        Dia := DATE2DMY(WORKDATE,1);
        Mes := DATE2DMY(WORKDATE,2);
        Ano := DATE2DMY(WORKDATE,3);
        
        IF ISCLEAR(FileSystem) THEN
        CREATE(FileSystem);
        
        Folder := rConfSant."Ubicacion XML Respuesta";
        
        IF ISCLEAR(Fiel_ifacere) THEN
          CREATE(Fiel_ifacere);
        
        Fiel_ifacere.RutaApp := Folder;
        
        Fiel_ifacere.ArchivoXML := rSIH."No. Comprobante Fiscal"+'.xml';
        Fiel_ifacere.Produccion := '1';
        Fiel_ifacere.TipoDocumento := 'F';
        
        //Cabecera
        Fiel_ifacere.StringXML := '<FACTURA><ENCABEZADO><NOFACTURA>'+NoFact+'</NOFACTURA><RESOLUCION>';
        Fiel_ifacere.StringXML := rNoSeriesLine."No. Resolucion"+'</RESOLUCION>';
        Fiel_ifacere.StringXML := '<IDSERIE>'+Serie+'</IDSERIE><EMPRESA>'+rConfSant."ID Empresa FE"+'</EMPRESA><SUCURSAL>';
        Fiel_ifacere.StringXML := rCodAlmacen."Cod. Sucursal"+'</SUCURSAL><CAJA>1</CAJA><USUARIO />';
        Fiel_ifacere.StringXML := '<FECHAEMISION>'+FORMAT(rSIH."Posting Date")+'</FECHAEMISION>';
        Fiel_ifacere.StringXML := '<GENERACION>'+TG+'</GENERACION><MONEDA>'+Moneda+'</MONEDA><TASACAMBIO>'+txtTasa+'</TASACAMBIO>';
        Fiel_ifacere.StringXML := '<NOMBRECONTRIBUYENTE><![CDATA['+rSIH."Sell-to Customer Name"+']]></NOMBRECONTRIBUYENTE>';
        Fiel_ifacere.StringXML := '<DIRECCIONCONTRIBUYENTE><![CDATA['+rSIH."Sell-to Address"+']]></DIRECCIONCONTRIBUYENTE>';
        Fiel_ifacere.StringXML := '<NITCONTRIBUYENTE>'+rSIH."VAT Registration No."+'</NITCONTRIBUYENTE><VALORNETO>';
        Fiel_ifacere.StringXML := txtValorNeto+'</VALORNETO><IVA>'+txtIVA+'</IVA><TOTAL>'+txtTotal+'<';
        Fiel_ifacere.StringXML := '/TOTAL><DESCUENTO>'+txtDtoFact+'</DESCUENTO><EXENTO>0</EXENTO><RAZONANULACION>ERROR</RAZONANULACION>';
        Fiel_ifacere.StringXML := '</ENCABEZADO>';
        Fiel_ifacere.StringXML := '<OPCIONAL><OPCIONAL1 /><OPCIONAL2>';
        Fiel_ifacere.StringXML := '</OPCIONAL2><OPCIONAL3></OPCIONAL3><OPCIONAL4></OPCIONAL4><OPCIONAL5></OPCIONAL5><OPCIONAL6>';
        Fiel_ifacere.StringXML := '</OPCIONAL6></OPCIONAL><DETALLE>';
        
        k:=0;
        REPEAT
         k+=1;
         Fiel_ifacere.StringXML := LinEnvio[k];
        
        UNTIL k = I1;
        
        //Lineas
        
        Fiel_ifacere.StringXML := '</DETALLE></FACTURA>';
        
        Fiel_ifacere.EjecutaWebService;
        
        IF Fiel_ifacere.Mensaje = '' THEN
          BEGIN
            IF Fiel_ifacere.pResultado = 'True' THEN
              BEGIN
                rSIH."Folio Anulado en Ifacere" := TRUE;
                rSIH.MODIFY;
                MESSAGE(txt002);
              END
            ELSE
              BEGIN
                BEGIN
                  MESSAGE(COPYSTR(Fiel_ifacere.pDescripcion,1,100));
                  MESSAGE(Text003);
                END;
              END;
          END
        ELSE
          IF GUIALLOWED THEN
            MESSAGE(txt0001);
        
        CLEAR(Fiel_ifacere);
        COMMIT;
        fes mig */

    end;


    procedure AnulaNotaCR(rSCMH: Record "Sales Cr.Memo Header")
    var
        rSCML: Record "Sales Cr.Memo Line";
    /*     FileSystem: Automation; */
        Ano: Integer;
        Mes: Integer;
        Dia: Integer;
        Folder: Text[1024];
        Nombre: Text[30];
        rSIH: Record "Sales Invoice Header";
    begin
        /* fes mig
        rSCMH.TESTFIELD("No. Comprobante Fiscal Rel.");
        DtoLin := 0;
        DtoFact := 0;
        I := 0;
        I1 := 0;
        CLEAR(LinEnvio);
        
        rCodAlmacen.GET(rSCMH."Location Code");
        rCodAlmacen.TESTFIELD("Cod. Sucursal");
        
        rConfSant.GET;
        rConfSant.TESTFIELD("Ubicacion XML Respuesta");
        
        rSCMH.CALCFIELDS(Amount);
        rSCMH.CALCFIELDS("Amount Including VAT");
        
        //Divisa
        IF rSCMH."Currency Code" = '' THEN
          BEGIN
            rGLS.GET;
            Moneda := UPPERCASE(rGLS."LCY Code");
            Tasa := 1;
            txtTasa := FORMAT(ROUND(Tasa),0,'<Precision,2:2><Standard format,0>');
          END
        ELSE
          BEGIN
            Moneda := UPPERCASE(rSCMH."Currency Code");
            Tasa := (rSCMH."Amount Including VAT"/rSCMH."Currency Factor");
            Tasa := (Tasa/rSCMH."Amount Including VAT");
            txtTasa := FORMAT(ROUND(Tasa),0,'<Precision,2:2><Standard format,0>');
          END;
        //Fin Divisa
        
        //Descuentos
        rSCML.RESET;
        rSCML.SETRANGE("Document No.",rSCMH."No.");
        rSCML.SETFILTER("No.",'<>%1','');
        IF rSCML.FINDSET THEN
          REPEAT
            I1 += 1;
        
            IF rSCMH."Prices Including VAT" THEN
              DtoLin := rSCML."Line Discount Amount"/(1+rSCML."VAT %"/100)
            ELSE
              DtoLin := rSCML."Line Discount Amount";
        
        
            IF rSCMH."Prices Including VAT" THEN
              DtoFact := rSCML."Inv. Discount Amount"/(1+rSCML."VAT %"/100)
            ELSE
              DtoFact := rSCML."Inv. Discount Amount";
        
            IF rSCMH."Prices Including VAT" THEN
              DtoLinTotal += rSCML."Line Discount Amount"/(1+rSCML."VAT %"/100)
            ELSE
              DtoLinTotal += rSCML."Line Discount Amount";
        
        
            IF rSCMH."Prices Including VAT" THEN
              DtoFactTotal += rSCML."Inv. Discount Amount"/(1+rSCML."VAT %"/100)
            ELSE
              DtoFactTotal += rSCML."Inv. Discount Amount";
        
        
            TotalDescuentos := DtoLin + DtoFact;
            txtCant := FORMAT(ROUND(rSCML.Quantity),0,'<Precision,2:2><Standard format,0>');
            IF rSCMH."Prices Including VAT" THEN
              txtPrecio := FORMAT((rSCML."Unit Price"/(1+rSCML."VAT %"/100)),0,'<Precision,2:5><Standard format,0>')
            ELSE
              txtPrecio := FORMAT(rSCML."Unit Price",0,'<Precision,2:5><Standard format,0>');
        
            txtImp := FORMAT(ROUND(rSCML.Amount+TotalDescuentos),0,'<Precision,2:2><Standard format,0>');
        
            LinEnvio[I1] :=
           '<LINEA><CANTIDAD>'+txtCant+'</CANTIDAD><DESCRIPCION>'+'<![CDATA['+rSCML.Description+']]></DESCRIPCION>'+
           '<METRICA>'+rSCML."Unit of Measure Code"+'</METRICA>'+
           '<PRECIOUNITARIO>'+txtPrecio+'</PRECIOUNITARIO><VALOR>'+txtImp+'</VALOR><DETALLE1>'+
           '<![CDATA['+rSCML."No."+']]></DETALLE1></LINEA>';
          UNTIL rSCML.NEXT = 0;
        
        txtDtoFact := FORMAT(ROUND(DtoLinTotal + DtoFactTotal),0,'<Precision,2:2><Standard format,0>');
        //Fin Descuentos
        
        //Importes
        txtValorNeto := FORMAT(ROUND(rSCMH.Amount),0,'<Precision,2:2><Standard format,0>');
        txtIVA := FORMAT(ROUND(rSCMH."Amount Including VAT" - rSCMH.Amount),0,'<Precision,2:2><Standard format,0>');
        txtTotal := FORMAT(ROUND(rSCMH."Amount Including VAT"-(DtoLinTotal + DtoFactTotal)),0,'<Precision,2:2><Standard format,0>');
        //Fin Importes
        
        //Mov. IVA
        rVatEntry.RESET;
        rVatEntry.SETCURRENTKEY("Document No.","Posting Date");
        rVatEntry.SETRANGE(rVatEntry."Document No.",rSCMH."No.");
        rVatEntry.SETRANGE(rVatEntry."Posting Date",rSCMH."Posting Date");
        rVatEntry.SETRANGE(rVatEntry."Document Type",rVatEntry."Document Type"::Invoice);
        IF rVatEntry.FINDSET THEN
          REPEAT
            IF rVatEntry.Amount = 0 THEN
              BEGIN
                Exento += rVatEntry.Base;
              END;
          UNTIL rVatEntry.NEXT = 0;
        
        txtExento := FORMAT(ROUND(Exento),0,'<Precision,2:2><Standard format,0>');
        //Fin Mov. IVA
        
        //Datos Factura
        I := 0;
        ParteNumerica := '';
        ParteSerie := '';
        Encontrado := FALSE;
        REPEAT
          I += 1;
          IF COPYSTR(rSCMH."No. Comprobante Fiscal",I,1) = '-' THEN
            Encontrado := TRUE;
        UNTIL (I = STRLEN(rSCMH."No. Comprobante Fiscal")) OR (Encontrado);
        
        NoFact := COPYSTR(rSCMH."No. Comprobante Fiscal",I+1,(STRLEN(rSCMH."No. Comprobante Fiscal")-(I)));
        Serie := COPYSTR(rSCMH."No. Comprobante Fiscal",1,I-1);
        //Fin Datos Cab. Factura
        
        //Para No. Comp. Relacionado
        I := 0;
        ParteNumerica := '';
        ParteSerie := '';
        Encontrado := FALSE;
        REPEAT
          I += 1;
          IF COPYSTR(rSCMH."No. Comprobante Fiscal Rel.",I,1) = '-' THEN
            Encontrado := TRUE;
        UNTIL (I = STRLEN(rSCMH."No. Comprobante Fiscal Rel.")) OR (Encontrado);
        
        NoFactRel := COPYSTR(rSCMH."No. Comprobante Fiscal Rel.",I+1,(STRLEN(rSCMH."No. Comprobante Fiscal Rel.")-(I)));
        SerieRel := COPYSTR(rSCMH."No. Comprobante Fiscal Rel.",1,I-1);
        //Para No. Comp. Relacionado
        
        
        rNoSeriesLine.RESET;
        rNoSeriesLine.SETRANGE("Series Code",rSCMH."No. Serie NCF Abonos");
        //rNoSeriesLine.SETRANGE(Open,TRUE);
        rNoSeriesLine.SETFILTER("Starting No.",'<=%1',rSCMH."No. Comprobante Fiscal");
        rNoSeriesLine.SETFILTER("Ending No.",'>=%1',rSCMH."No. Comprobante Fiscal");
        rNoSeriesLine.FINDFIRST;
        
        rNoSeriesLine.TESTFIELD("Tipo Generacion");
        IF rNoSeriesLine."Tipo Generacion" = rNoSeriesLine."Tipo Generacion"::Resguardo THEN
          TG := 'C'
        ELSE
          TG := 'O';
        
        
        Folder := rConfSant."Ubicacion XML Respuesta";
        
        IF ISCLEAR(Fiel_ifacere) THEN
          CREATE(Fiel_ifacere);
        
        Fiel_ifacere.RutaApp := Folder;
        
        Fiel_ifacere.ArchivoXML := rSCMH."No. Comprobante Fiscal"+'.xml';
        
        Fiel_ifacere.Produccion := '1';
        Fiel_ifacere.TipoDocumento := 'N';
        
        IF NOT rSIH.GET(rSCMH."Applies-to Doc. No.") THEN
          BEGIN
            rSIH.RESET;
            rSIH.SETCURRENTKEY(rSIH."No. Comprobante Fiscal");
            rSIH.SETRANGE(rSIH."No. Comprobante Fiscal",rSCMH."No. Comprobante Fiscal Rel.");
            rSIH.FINDFIRST;
          END;
        
        IF rSCMH."Pre-Assigned No." <> '' THEN
          Concepto := 'ANULACION'
        ELSE
          Concepto := 'DEVOLUCION';
        
        
        //Cabecera
        Fiel_ifacere.StringXML := '<NOTACREDITO><ENCABEZADO><NODOCUMENTO>'+NoFact+'</NODOCUMENTO><RESOLUCION>';
        Fiel_ifacere.StringXML := rNoSeriesLine."No. Resolucion"+'</RESOLUCION>';
        Fiel_ifacere.StringXML := '<IDSERIE>'+Serie+'</IDSERIE><EMPRESA>'+rConfSant."ID Empresa FE"+'</EMPRESA><SUCURSAL>';
        Fiel_ifacere.StringXML := rCodAlmacen."Cod. Sucursal"+'</SUCURSAL><CAJA>1</CAJA><USUARIO />';
        Fiel_ifacere.StringXML := '<FECHAEMISION>'+FORMAT(rSCMH."Posting Date")+'</FECHAEMISION>';
        Fiel_ifacere.StringXML := '<GENERACION>'+TG+'</GENERACION><MONEDA>'+Moneda+'</MONEDA><TASACAMBIO>'+txtTasa+'</TASACAMBIO>';
        Fiel_ifacere.StringXML := '<NOMBRECONTRIBUYENTE><![CDATA['+rSCMH."Sell-to Customer Name"+']]></NOMBRECONTRIBUYENTE>';
        Fiel_ifacere.StringXML := '<DIRECCIONCONTRIBUYENTE><![CDATA['+rSCMH."Sell-to Address"+']]></DIRECCIONCONTRIBUYENTE>';
        Fiel_ifacere.StringXML := '<NITCONTRIBUYENTE>'+rSCMH."VAT Registration No."+'</NITCONTRIBUYENTE><VALORNETO>';
        Fiel_ifacere.StringXML := txtValorNeto+'</VALORNETO><IVA>'+txtIVA+'</IVA><TOTAL>'+txtTotal+'<';
        Fiel_ifacere.StringXML := '/TOTAL><DESCUENTO>'+txtDtoFact+'</DESCUENTO>';
        Fiel_ifacere.StringXML := '<NOFACTURA>'+NoFactRel+'</NOFACTURA>';
        Fiel_ifacere.StringXML := '<SERIEFACTURA>'+SerieRel+'</SERIEFACTURA>';
        Fiel_ifacere.StringXML := '<FECHAFACTURA>'+FORMAT(rSIH."Posting Date")+'</FECHAFACTURA>';
        Fiel_ifacere.StringXML := '<CONCEPTO>'+Concepto+'</CONCEPTO><RAZONANULACION>ERROR</RAZONANULACION>';
        Fiel_ifacere.StringXML := '</ENCABEZADO>';
        Fiel_ifacere.StringXML := '<OPCIONAL></OPCIONAL>';
        Fiel_ifacere.StringXML := '<DETALLE>';
        
        k:=0;
        REPEAT
         k+=1;
         Fiel_ifacere.StringXML := LinEnvio[k];
        
        UNTIL k = I1;
        
        //Lineas
        
        Fiel_ifacere.StringXML := '</DETALLE></NOTACREDITO>';
        
        Fiel_ifacere.EjecutaWebService;
        
        
        IF Fiel_ifacere.pResultado = 'True' THEN
          BEGIN
            rSCMH."Folio Anulado en Ifacere" := TRUE;
            rSCMH.MODIFY;
            MESSAGE(txt002);
          END
        ELSE
          MESSAGE(txt004);
        
        CLEAR(Fiel_ifacere);
        COMMIT;
        fes mig */

    end;
}

