codeunit 56201 "Informacion Complementaria MDE"
{
    // #72814  27/06/2017 PLB: Posibilidad de exportar el IRM a Excel
    // #168444 05/09/2018 PLB: Error en el filtro sobre las cargas sociales, el problema aparecía donde se generan nóminas quincenales y se aplican cargas sociales en ambas quincenas
    // #269159 07/10/2019 RRT: Corrección en la función GetEmployeeFTE()


    trigger OnRun()
    begin
        //IRM(011116D, 301116D, 'EMP-00003',TRUE);
    end;

    var
        ConfSant: Record "Config. Empresa";
        ExcelBuffer: Record "Excel Buffer" temporary;
        MdEMgnt: Codeunit "MdE Management";
        /*         XmlDoc: DotNet XmlDocument;
                XmlNode: DotNet XmlNode; */
        NS: Label 'inf';
        NSUri: Label 'http://InformacionComplementariaMDE.santillana.local';
        Text002: Label 'Esta dimensión predeterminada se gestiona desde el MdE.';
        Text010: Label 'IRM';
        Text011: Label 'Información Real Mensual';
        InStr: InStream;


    procedure IRM(FromDate: Date; ToDate: Date; Filtro_Empleado: Text[100]; SendToExcel: Boolean)
    var
        HistLinNom: Record "Historico Lin. nomina";
        Employee: Record Employee;
        LinAporEmp: Record "Lin. Aportes Empresas";
        PerfilSalarial: Record "Perfil Salarial";
        ProvisionesNom: Record "Provisiones nominas11";
        MdEMgnt: Codeunit "MdE Management";
        Response: Text;
        ImportesIRM: array[20] of Decimal;
        EmployeeFTE: Decimal;
    begin
        ConfSant.Get;
        ConfSant.TestField("WS Informacion Compl. MdE");
        ConfSant.TestField("Cod. pais maestros Santill");
        ConfSant.TestField("Cod. divisa local MdX");

        if Filtro_Empleado <> '' then
            Employee.SetFilter("No.", Filtro_Empleado);
        if Employee.FindSet then begin
            //+#72814
            if SendToExcel then
                HeadIRMExcel;
            //-#72814
            repeat
                Clear(ImportesIRM);
                Clear(EmployeeFTE);

                // Acumulamos por empleado
                // No. empleado,Tipo Nómina,Período,No. Orden
                HistLinNom.SetRange("No. empleado", Employee."No.");
                HistLinNom.SetRange(Período, FromDate, ToDate);
                if HistLinNom.FindSet then
                    repeat
                        if HistLinNom."Tipo concepto" = HistLinNom."Tipo concepto"::Ingresos then // las aportaciones las procesamos en el siguiente bucle
                            CalcIRM(HistLinNom."Concepto salarial", ImportesIRM, HistLinNom.Total);
                    until HistLinNom.Next = 0;

                // Aportación de la empresa
                // Período,Tipo Nomina,No. Empleado,No. orden
                //LinAporEmp.SETRANGE(Período, HistLinNom.Período); //-#168444
                LinAporEmp.SetRange(Período, FromDate, ToDate); //+#168444
                LinAporEmp.SetRange("No. Empleado", Employee."No.");
                if LinAporEmp.FindSet then
                    repeat
                        CalcIRM(LinAporEmp."Concepto Salarial", ImportesIRM, LinAporEmp.Importe);
                    until LinAporEmp.Next = 0;

                //+#72814
                // Conceptos prorrateados
                ProvisionesNom.SetRange("Cod. Empleado", Employee."No.");
                ProvisionesNom.SetRange(Periodo, FromDate, ToDate);
                if ProvisionesNom.FindSet then
                    repeat
                        CalcIRM(ProvisionesNom."Concepto Salarial", ImportesIRM, ProvisionesNom."Importe provisionado");
                    until ProvisionesNom.Next = 0;
                //-#72814

                EmployeeFTE := GetEmployeeFTE(Employee."No.", FromDate, ToDate);
                if HayImporte(ImportesIRM) or (EmployeeFTE <> 0) then begin
                    //+#72814
                    // sustituido por la tabla "Provisiones nominas" procesada más arriba
                    //PerfilSalarial.SETRANGE("No. empleado", Employee."No.");
                    //PerfilSalarial.SETRANGE(Prorratear, TRUE);
                    //IF PerfilSalarial.FINDSET THEN
                    //  REPEAT
                    //    CalcIRM(PerfilSalarial."Concepto salarial",ImportesIRM,ConceptoProrrateado(PerfilSalarial,HistLinNom.Período));
                    //  UNTIL PerfilSalarial.NEXT = 0;

                    if SendToExcel then
                        BodyIRMExcel(Employee."No.", ImportesIRM, FromDate, ToDate, EmployeeFTE, GetEstadoIRM(Employee.Status.AsInteger()))
                    else begin
                        //-#72814
                        Head('irm');
                        BodyIRM(Employee."No.", ImportesIRM, FromDate, ToDate, EmployeeFTE, GetEstadoIRM(Employee.Status.AsInteger()));
                        MdEMgnt.SendPostRequest(ConfSant."WS Informacion Compl. MdE", '', 'XmlDoc.OuterXml');
                    end; //+#72814
                end;
            until Employee.Next = 0;

            //+#72814
            if SendToExcel then begin
                /*    ExcelBuffer.CreateBook('', Text010); */
                ExcelBuffer.WriteSheet(Text011, CompanyName, UserId);
                ExcelBuffer.CloseBook;
                ExcelBuffer.OpenExcel;
                ExcelBuffer.UpdateBookStream(InStr, Text011, true);
            end;
            //-#72814
        end;
    end;


    procedure Ceco(var DimVal: Record "Dimension Value"; xRec: Record "Dimension Value"; TipoOper: Option Insert,Modify,Delete,Rename)
    var
        vBlocked: Boolean;
    begin
        ConfSant.Get;
        if (not ConfSant."MdE Activo") or (ConfSant."Dimension Centro Coste" = '') then
            exit;

        if DimVal."Dimension Code" <> ConfSant."Dimension Centro Coste" then begin
            // en un rename del cód. dimension, si el cód. anterior es de centro de coste, enviamos un delete del anterior
            if (TipoOper = TipoOper::Rename) and (xRec."Dimension Code" = ConfSant."Dimension Centro Coste") then
                Ceco(xRec, xRec, TipoOper::Delete);

            exit;
        end;

        if not (DimVal."Dimension Value Type"::Standard in [DimVal."Dimension Value Type", xRec."Dimension Value Type"]) then
            exit;

        if (TipoOper = TipoOper::Modify) then begin

            // Si el tipo dim. es estándar y el anterior no, provocamos un insert
            if (DimVal."Dimension Value Type" = DimVal."Dimension Value Type"::Standard) and
               (xRec."Dimension Value Type" <> xRec."Dimension Value Type"::Standard) then
                TipoOper := TipoOper::Insert

            // Si el tipo dim. anterior es estándar y el actual no, provocamos un delete
            else
                if (DimVal."Dimension Value Type" <> DimVal."Dimension Value Type"::Standard) and
              (xRec."Dimension Value Type" = xRec."Dimension Value Type"::Standard) then
                    TipoOper := TipoOper::Delete;
        end;

        // no hacemos nada si no cambia el nombre ni el bloqueado
        if (TipoOper = TipoOper::Modify) and (DimVal.Name = xRec.Name) and (DimVal.Blocked = xRec.Blocked) then
            exit;

        if TipoOper = TipoOper::Rename then begin
            if xRec."Dimension Code" = ConfSant."Dimension Centro Coste" then
                Ceco(xRec, xRec, TipoOper::Delete);
            TipoOper := TipoOper::Insert;
            DimVal."Fecha creacion" := Today;
        end;

        if TipoOper = TipoOper::Insert then
            DimVal."Fecha creacion" := Today;

        vBlocked := (TipoOper = TipoOper::Delete) or (DimVal.Blocked);

        ConfSant.TestField("WS Informacion Compl. MdE");
        ConfSant.TestField("Cod. pais maestros Santill");

        Head('ceco');
        BodyCC(ConfSant."Cod. sociedad maestros Santill" + '_' + DimVal.Code, DimVal.Name, DimVal."Fecha creacion", GetEstadoCC(vBlocked));
        //ERROR(XmlDoc.OuterXml); //temp

        // Envío asíncrono: se realiza la petición en background (en otra sesión) para que la actual no quede parada hasta recibir respuesta del WS
        MdEMgnt.CreateAsyncPostRequest('CECO', ConfSant."WS Informacion Compl. MdE", '', 'XmlDoc.OuterXml');
    end;


    procedure HorariosCeco(DefaultDim: Record "Default Dimension")
    var
        DimVal: Record "Dimension Value";
        Contrato: Record Contratos;
        GradoOcu: Decimal;
    begin
        if DefaultDim."Table ID" <> DATABASE::Employee then
            exit;

        if (DefaultDim."No." = '') or (DefaultDim."Dimension Value Code" = '') then
            exit;

        ConfSant.Get;
        if not ConfSant."MdE Activo" then
            exit;

        ValidarDim(DefaultDim);

        if (ConfSant."Dimension Centro Coste" = '') or (DefaultDim."Dimension Code" <> ConfSant."Dimension Centro Coste") then
            exit;

        ConfSant.TestField("WS Informacion Compl. MdE");
        ConfSant.TestField("Cod. pais maestros Santill");

        if DefaultDim."Dimension Code" <> ConfSant."Dimension Centro Coste" then
            exit;

        Contrato.SetRange("No. empleado", DefaultDim."No.");
        Contrato.SetFilter("Fecha inicio", '<=%1', WorkDate);
        Contrato.SetFilter("Fecha finalización", '>=%1', WorkDate);
        if Contrato.IsEmpty then
            Contrato.SetRange("Fecha finalización", 0D);
        if Contrato.IsEmpty then
            GradoOcu := 100
        else begin
            Contrato.FindLast;
            if Contrato."Grado ocupacion" = 0 then
                GradoOcu := 100
            else
                GradoOcu := Contrato."Grado ocupacion";
        end;

        Head('horariosceco');
        BodyHCC(DefaultDim."No.", ConfSant."Cod. sociedad maestros Santill" + '_' + DefaultDim."Dimension Value Code", GradoOcu);
        //ERROR(XmlDoc.OuterXml); //temp

        // Envío asíncrono: se realiza la petición en background (en otra sesión) para que la actual no quede parada hasta recibir respuesta del WS
        MdEMgnt.CreateAsyncPostRequest('HORARIOSCECO', ConfSant."WS Informacion Compl. MdE", '', 'XmlDoc.OuterXml');
    end;


    procedure ValidarDim(DefaultDim: Record "Default Dimension")
    begin
        if DefaultDim."Dimension Code" in [ConfSant."Dimension Departamento", ConfSant."Dimension Division", ConfSant."Dimension Area funcional"] then
            Error(Text002);
    end;


    procedure CT(Filtro_Empleado: Text[100])
    var
        Employee: Record Employee;
        PerfSal: Record "Perfil Salarial";
        ImportesCT: array[20] of Decimal;
    begin
        ConfSant.Get;
        ConfSant.TestField("WS Informacion Compl. MdE");
        ConfSant.TestField("Cod. pais maestros Santill");
        ConfSant.TestField("Cod. divisa local MdX");

        //TODO: falta frecuencia y número de pagas

        Employee.Reset;
        if Filtro_Empleado <> '' then
            Employee.SetFilter("No.", Filtro_Empleado);
        if Employee.FindSet then
            repeat
                Clear(ImportesCT);

                PerfSal.SetRange("No. empleado", Employee."No.");
                if PerfSal.FindSet then begin
                    repeat
                        CalcCT(PerfSal."Concepto salarial", ImportesCT, PerfSal.Importe);
                    until PerfSal.Next = 0;

                    if HayImporte(ImportesCT) then begin
                        Head('ct');
                        BodyCT(Employee."No.", ImportesCT);
                        //ERROR(XmlDoc.OuterXml); //temp
                        MdEMgnt.SendPostRequest(ConfSant."WS Informacion Compl. MdE", '', 'XmlDoc.OuterXml');
                    end;
                end;
            until Employee.Next = 0;
    end;

    local procedure Head(Funcion: Text[30])
    var
        /*         XmlNsMgr: DotNet XmlNamespaceManager;
                XmlNode2: DotNet XmlNode;
                XmlNode3: DotNet XmlNode; */
        MyDT: DateTime;
    begin
        MyDT := RoundDateTime(CurrentDateTime);

        /*    Clear(XmlDoc);

           XmlDoc := XmlDoc.XmlDocument;
           XmlDoc.LoadXml(
           '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:inf="http://InformacionComplementariaMDE.santillana.local">' +
           '<soapenv:Header/>' +
           '<soapenv:Body>' +
           '<inf:' + Funcion + '>' +
           '<inf:mensaje/>' +
           '</inf:' + Funcion + '>' +
           '</soapenv:Body>' +
           '</soapenv:Envelope>');

           XmlNsMgr := XmlNsMgr.XmlNamespaceManager(XmlDoc.NameTable);
           XmlNsMgr.AddNamespace('soapenv', 'http://schemas.xmlsoap.org/soap/envelope/');
           XmlNsMgr.AddNamespace('inf', 'http://InformacionComplementariaMDE.santillana.local');

           // nivel 0
           XmlNode := XmlDoc.SelectSingleNode('//soapenv:Body/inf:' + Funcion + '/inf:mensaje', XmlNsMgr);

           // nivel 1
           MdEMgnt.AddElement(XmlNode, 'head', '', NS, NSUri, XmlNode2);

           // nivel 2
           MdEMgnt.AddElement(XmlNode2, 'id_mensaje', '', NS, NSUri, XmlNode3); //TODO: ¿contador?
           MdEMgnt.AddElement(XmlNode2, 'sistema_origen', ConfSant.GetSistemaOrigen, NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'pais_origen', ConfSant."Cod. pais maestros Santill", NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'fecha_origen', MdEMgnt.FormatDateTime(Today, Time), NS, NSUri, XmlNode3); // hoy
           MdEMgnt.AddElement(XmlNode2, 'tipo', '0039', NS, NSUri, XmlNode3); //valor fijo "0039" */
    end;

    local procedure HeadIRMExcel()
    begin
        ExcelBuffer.NewRow;

        ExcelBuffer.AddColumn('Sociedad', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Empleado', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('PeriodoDesde', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('PeriodoHasta', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Estado', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('FTE', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('SalanFI', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('MonedaSLF', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn('CompSalanFIJ', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('MonedaCSF', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('CompVariable', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('MonedaCV', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn('SaFijTot', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('MonedaSFT', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn('BonoDeven', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('MonedaBD', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('BonoPagado', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('MonedaBP', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('VarComercial', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('MonedaVC', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('VarComerialDE', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('MonedaVCD', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Gratificacion', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('MonedaG', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('ILPDeven', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('MonedaILPD', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('ILPPagado', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('MonedaILPP', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Colaboraciones', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('MonedaC', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn('CargasSociales', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('MonedaCS', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('OtrosGastos', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('MonedaOG', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn('Indemnizacion', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('MonedaI', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure BodyIRM(EmployeeNo: Code[20]; ImportesIRM: array[20] of Decimal; FromDate: Date; ToDate: Date; FTE: Decimal; Status: Text[1])
    var
        EquivVavMde: Record "Equiv. conceptos NAV-MdE";
    /*    XmlNode2: DotNet XmlNode;
       XmlNode3: DotNet XmlNode; */
    begin

        // nivel 1
        /*    MdEMgnt.AddElement(XmlNode, 'body', '', NS, NSUri, XmlNode2);

           // nivel 2
           MdEMgnt.AddElement(XmlNode2, 'Sociedad', ConfSant."Cod. sociedad maestros Santill", NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'Empleado', EmployeeNo, NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'PeriodoDesde', MdEMgnt.FormatDate(FromDate), NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'PeriodoHasta', MdEMgnt.FormatDate(ToDate), NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'Estado', Status, NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'FTE', Format(FTE, 0, 9), NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'SalanFI', Format(ImportesIRM[EquivVavMde."Concepto IRM"::SalanFI], 0, 9), NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'MonedaSLF', ConfSant."Cod. divisa local MdX", NS, NSUri, XmlNode3);

           MdEMgnt.AddElement(XmlNode2, 'CompSalanFIJ', Format(ImportesIRM[EquivVavMde."Concepto IRM"::CompSalanFIJ], 0, 9), NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'MonedaCSF', ConfSant."Cod. divisa local MdX", NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'CompVariable', Format(ImportesIRM[EquivVavMde."Concepto IRM"::CompVariable], 0, 9), NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'MonedaCV', ConfSant."Cod. divisa local MdX", NS, NSUri, XmlNode3);

           MdEMgnt.AddElement(XmlNode2, 'SaFijTot', Format(ImportesIRM[EquivVavMde."Concepto IRM"::SaFijTot], 0, 9), NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'MonedaSFT', ConfSant."Cod. divisa local MdX", NS, NSUri, XmlNode3);

           MdEMgnt.AddElement(XmlNode2, 'BonoDeven', Format(ImportesIRM[EquivVavMde."Concepto IRM"::BonoDeven], 0, 9), NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'MonedaBD', ConfSant."Cod. divisa local MdX", NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'BonoPagado', Format(ImportesIRM[EquivVavMde."Concepto IRM"::BonoPagado], 0, 9), NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'MonedaBP', ConfSant."Cod. divisa local MdX", NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'VarComercial', Format(ImportesIRM[EquivVavMde."Concepto IRM"::VarComercial], 0, 9), NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'MonedaVC', ConfSant."Cod. divisa local MdX", NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'VarComerialDE', Format(ImportesIRM[EquivVavMde."Concepto IRM"::VarComerialDE], 0, 9), NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'MonedaVCD', ConfSant."Cod. divisa local MdX", NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'Gratificacion', Format(ImportesIRM[EquivVavMde."Concepto IRM"::Gratificacion], 0, 9), NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'MonedaG', ConfSant."Cod. divisa local MdX", NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'ILPDeven', Format(ImportesIRM[EquivVavMde."Concepto IRM"::ILPDeven], 0, 9), NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'MonedaILPD', ConfSant."Cod. divisa local MdX", NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'ILPPagado', Format(ImportesIRM[EquivVavMde."Concepto IRM"::ILPPagado], 0, 9), NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'MonedaILPP', ConfSant."Cod. divisa local MdX", NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'Colaboraciones', Format(ImportesIRM[EquivVavMde."Concepto IRM"::Colaboraciones], 0, 9), NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'MonedaC', ConfSant."Cod. divisa local MdX", NS, NSUri, XmlNode3);

           MdEMgnt.AddElement(XmlNode2, 'CargasSociales', Format(ImportesIRM[EquivVavMde."Concepto IRM"::CargasSociales], 0, 9), NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'MonedaCS', ConfSant."Cod. divisa local MdX", NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'OtrosGastos', Format(ImportesIRM[EquivVavMde."Concepto IRM"::OtrosGastos], 0, 9), NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'MonedaOG', ConfSant."Cod. divisa local MdX", NS, NSUri, XmlNode3);

           MdEMgnt.AddElement(XmlNode2, 'Indemnizacion', Format(ImportesIRM[EquivVavMde."Concepto IRM"::Indemnizacion], 0, 9), NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'MonedaI', ConfSant."Cod. divisa local MdX", NS, NSUri, XmlNode3); */
    end;

    local procedure BodyIRMExcel(EmployeeNo: Code[20]; ImportesIRM: array[20] of Decimal; FromDate: Date; ToDate: Date; FTE: Decimal; Status: Text[1])
    var
        EquivVavMde: Record "Equiv. conceptos NAV-MdE";
    begin
        // nivel 2
        ExcelBuffer.NewRow;

        ExcelBuffer.AddColumn(ConfSant."Cod. sociedad maestros Santill", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(EmployeeNo, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(FromDate, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn(ToDate, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn(Status, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(FTE, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(ImportesIRM[EquivVavMde."Concepto IRM"::SalanFI], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(ConfSant."Cod. divisa local MdX", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn(ImportesIRM[EquivVavMde."Concepto IRM"::CompSalanFIJ], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(ConfSant."Cod. divisa local MdX", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ImportesIRM[EquivVavMde."Concepto IRM"::CompVariable], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(ConfSant."Cod. divisa local MdX", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn(ImportesIRM[EquivVavMde."Concepto IRM"::SaFijTot], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(ConfSant."Cod. divisa local MdX", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn(ImportesIRM[EquivVavMde."Concepto IRM"::BonoDeven], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(ConfSant."Cod. divisa local MdX", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ImportesIRM[EquivVavMde."Concepto IRM"::BonoPagado], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(ConfSant."Cod. divisa local MdX", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ImportesIRM[EquivVavMde."Concepto IRM"::VarComercial], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(ConfSant."Cod. divisa local MdX", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ImportesIRM[EquivVavMde."Concepto IRM"::VarComerialDE], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(ConfSant."Cod. divisa local MdX", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ImportesIRM[EquivVavMde."Concepto IRM"::Gratificacion], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(ConfSant."Cod. divisa local MdX", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ImportesIRM[EquivVavMde."Concepto IRM"::ILPDeven], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(ConfSant."Cod. divisa local MdX", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ImportesIRM[EquivVavMde."Concepto IRM"::ILPPagado], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(ConfSant."Cod. divisa local MdX", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ImportesIRM[EquivVavMde."Concepto IRM"::Colaboraciones], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(ConfSant."Cod. divisa local MdX", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn(ImportesIRM[EquivVavMde."Concepto IRM"::CargasSociales], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(ConfSant."Cod. divisa local MdX", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(ImportesIRM[EquivVavMde."Concepto IRM"::OtrosGastos], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(ConfSant."Cod. divisa local MdX", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn(ImportesIRM[EquivVavMde."Concepto IRM"::Indemnizacion], false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(ConfSant."Cod. divisa local MdX", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    end;

    local procedure BodyCC(Codigo: Code[30]; Descripcion: Text[50]; FechaIni: Date; Estado: Text[1])
    var
    /*   XmlNode2: DotNet XmlNode;
      XmlNode3: DotNet XmlNode; */
    begin
        if FechaIni = 0D then
            FechaIni := 20000101D;

        // nivel 1
        /* MdEMgnt.AddElement(XmlNode, 'body', '', NS, NSUri, XmlNode2);

        // nivel 2
        MdEMgnt.AddElement(XmlNode2, 'Codigo', Codigo, NS, NSUri, XmlNode3);
        MdEMgnt.AddElement(XmlNode2, 'FechaIni', MdEMgnt.FormatDate(FechaIni), NS, NSUri, XmlNode3);
        MdEMgnt.AddElement(XmlNode2, 'Estado', Estado, NS, NSUri, XmlNode3);
        MdEMgnt.AddElement(XmlNode2, 'Nombre', Descripcion, NS, NSUri, XmlNode3);
        MdEMgnt.AddElement(XmlNode2, 'SociedadCO', ConfSant."Cod. Sociedad CO maestros", NS, NSUri, XmlNode3); */
    end;

    local procedure BodyHCC(EmployeeNo: Code[20]; DimensionValue: Code[30]; GradoOcu: Decimal)
    var
    /*   XmlNode2: DotNet XmlNode;
      XmlNode3: DotNet XmlNode; */
    begin
        // nivel 1
        /*  MdEMgnt.AddElement(XmlNode, 'body', '', NS, NSUri, XmlNode2);

         // nivel 2
         MdEMgnt.AddElement(XmlNode2, 'Sociedad', ConfSant."Cod. sociedad maestros Santill", NS, NSUri, XmlNode3);
         MdEMgnt.AddElement(XmlNode2, 'MotivEvSFSF', 'DAT-PER2', NS, NSUri, XmlNode3); //Valor fijo: DAT-PER2
         MdEMgnt.AddElement(XmlNode2, 'FechaEfectiva', MdEMgnt.FormatDateTime(Today, Time), NS, NSUri, XmlNode3);
         MdEMgnt.AddElement(XmlNode2, 'Empleado', EmployeeNo, NS, NSUri, XmlNode3);
         MdEMgnt.AddElement(XmlNode2, 'PorOcupa', Format(GradoOcu), NS, NSUri, XmlNode3);
         MdEMgnt.AddElement(XmlNode2, 'Ceco1', DimensionValue, NS, NSUri, XmlNode3);
         MdEMgnt.AddElement(XmlNode2, 'PorCeco1', '100', NS, NSUri, XmlNode3);
         MdEMgnt.AddElement(XmlNode2, 'Ceco2', '', NS, NSUri, XmlNode3);
         MdEMgnt.AddElement(XmlNode2, 'PorCeco2', '0', NS, NSUri, XmlNode3);
         MdEMgnt.AddElement(XmlNode2, 'Ceco3', '', NS, NSUri, XmlNode3);
         MdEMgnt.AddElement(XmlNode2, 'PorCeco3', '0', NS, NSUri, XmlNode3);
         MdEMgnt.AddElement(XmlNode2, 'Ceco4', '', NS, NSUri, XmlNode3);
         MdEMgnt.AddElement(XmlNode2, 'PorCeco4', '0', NS, NSUri, XmlNode3);
         MdEMgnt.AddElement(XmlNode2, 'Ceco5', '', NS, NSUri, XmlNode3);
         MdEMgnt.AddElement(XmlNode2, 'PorCeco5', '0', NS, NSUri, XmlNode3);
         MdEMgnt.AddElement(XmlNode2, 'Ceco6', '', NS, NSUri, XmlNode3);
         MdEMgnt.AddElement(XmlNode2, 'PorCeco6', '0', NS, NSUri, XmlNode3);
         MdEMgnt.AddElement(XmlNode2, 'Ceco7', '', NS, NSUri, XmlNode3);
         MdEMgnt.AddElement(XmlNode2, 'PorCeco7', '0', NS, NSUri, XmlNode3);
         MdEMgnt.AddElement(XmlNode2, 'Ceco8', '', NS, NSUri, XmlNode3);
         MdEMgnt.AddElement(XmlNode2, 'PorCeco8', '0', NS, NSUri, XmlNode3); */
    end;

    local procedure BodyCT(EmployeeNo: Code[20]; ImportesCT: array[20] of Decimal)
    var
        EquivVavMde: Record "Equiv. conceptos NAV-MdE";
    /*  XmlNode2: DotNet XmlNode;
     XmlNode3: DotNet XmlNode; */
    begin
        // nivel 1
        /*    MdEMgnt.AddElement(XmlNode, 'body', '', NS, NSUri, XmlNode2);

           // nivel 2
           MdEMgnt.AddElement(XmlNode2, 'Sociedad', ConfSant."Cod. sociedad maestros Santill", NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'MotEvSFSF', 'DAT-RETR3', NS, NSUri, XmlNode3); //TODO: Valor fijo: DAT-RETR3????
           MdEMgnt.AddElement(XmlNode2, 'FechaEfectiva', MdEMgnt.FormatDateTime(Today, Time), NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'Empleado', EmployeeNo, NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'NPagas', '12', NS, NSUri, XmlNode3); //TODO: pagas anuales
           MdEMgnt.AddElement(XmlNode2, 'Salario', Format(ImportesCT[EquivVavMde."Concepto CT"::Salario], 0, 9), NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'MonedaS', ConfSant."Cod. divisa local MdX", NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'FreqS', 'MENSUAL', NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'Comple', Format(ImportesCT[EquivVavMde."Concepto CT"::Comple], 0, 9), NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'MonedaC', ConfSant."Cod. divisa local MdX", NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'FreqC', 'MENSUAL', NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'Bono', Format(ImportesCT[EquivVavMde."Concepto CT"::Bono], 0, 9), NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'MonedaB', ConfSant."Cod. divisa local MdX", NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'FreqB', 'MENSUAL', NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'ILP', Format(ImportesCT[EquivVavMde."Concepto CT"::ILP], 0, 9), NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'MonedaILP', ConfSant."Cod. divisa local MdX", NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'FreqILP', 'MENSUAL', NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'VarCom', Format(ImportesCT[EquivVavMde."Concepto CT"::VarCom], 0, 9), NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'MonedaVC', ConfSant."Cod. divisa local MdX", NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'FreqVC', 'MENSUAL', NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'Rappel', Format(ImportesCT[EquivVavMde."Concepto CT"::Rappel], 0, 9), NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'MonedaR', ConfSant."Cod. divisa local MdX", NS, NSUri, XmlNode3);
           MdEMgnt.AddElement(XmlNode2, 'FreqR', 'MENSUAL', NS, NSUri, XmlNode3); */
    end;

    local procedure CalcIRM(Concepto: Code[20]; var Importes: array[20] of Decimal; ImporteConcepto: Decimal)
    begin
        CalcConcepto(Concepto, 0, Importes, ImporteConcepto);
    end;

    local procedure CalcCT(Concepto: Code[20]; var Importes: array[20] of Decimal; ImporteConcepto: Decimal)
    begin
        CalcConcepto(Concepto, 1, Importes, ImporteConcepto);
    end;

    local procedure CalcConcepto(Concepto: Code[20]; MdEType: Option IRM,CT; var Importes: array[20] of Decimal; ImporteConcepto: Decimal): Boolean
    var
        EquivNavMde: Record "Equiv. conceptos NAV-MdE";
    begin
        if ImporteConcepto = 0 then
            exit;

        EquivNavMde.Reset;
        EquivNavMde.SetRange("Concepto NAV", Concepto);
        if MdEType = MdEType::IRM then
            EquivNavMde.SetRange("Concepto CT", 0)
        else
            EquivNavMde.SetRange("Concepto IRM", 0);
        if EquivNavMde.FindSet then
            repeat
                if MdEType = MdEType::IRM then
                    Importes[EquivNavMde."Concepto IRM"] += ImporteConcepto * EquivNavMde.Porcentaje
                else
                    Importes[EquivNavMde."Concepto CT"] += ImporteConcepto * EquivNavMde.Porcentaje;
            until EquivNavMde.Next = 0;
    end;

    local procedure HayImporte(Importes: array[20] of Decimal): Boolean
    var
        i: Integer;
    begin
        for i := 1 to ArrayLen(Importes) do begin
            if Importes[i] <> 0 then
                exit(true);
        end;
    end;

    local procedure GetEstadoIRM(Status: Option Active,Inactive,Terminated): Text[1]
    begin
        if Status = Status::Active then
            exit('A')
        else
            exit('I');
    end;

    local procedure GetEstadoCC(Blocked: Boolean): Text[1]
    begin
        if Blocked then
            exit('I')
        else
            exit('A');
    end;

    local procedure GetEmployeeFTE(EmployeeNo: Code[20]; FromDate: Date; ToDate: Date) FTE: Decimal
    var
        Contrato: Record Contratos;
        DaysOfMonth: Integer;
        DaysWorked: Integer;
        lFechaInicioContratoAnterior: Date;
        lFechaFinalizacion: Date;
        lStop: Boolean;
        lContador: Integer;
    begin
        //+#269159
        //... Este cálculo sólo tiene en cuenta la existencia de 1 contrato en el periodo indicado.
        /*
        Contrato.SETRANGE("No. empleado", EmployeeNo);
        Contrato.SETFILTER("Fecha inicio", '..%1', ToDate);
        Contrato.SETFILTER("Fecha finalización", '%1..', FromDate);
        IF NOT Contrato.FINDLAST THEN
          Contrato.SETRANGE("Fecha finalización", 0D);
        IF Contrato.FINDLAST THEN BEGIN
          // si no se ha establecido el grado de ocupación, supondremos un 100%
          IF Contrato."Grado ocupacion" = 0 THEN
            Contrato."Grado ocupacion" := 100;
        
          DaysOfMonth := (ToDate - FromDate) + 1;
          DaysWorked := DATE2DMY(ToDate,1) - DATE2DMY(FromDate,1) + 1;
        
          IF Contrato."Fecha inicio" > FromDate THEN
            DaysWorked := DaysWorked - (Contrato."Fecha inicio" - FromDate);
        
          IF (Contrato."Fecha finalización" < ToDate) AND (Contrato."Fecha finalización" <> 0D) THEN
            DaysWorked := DaysWorked - (ToDate - Contrato."Fecha finalización");
        
          FTE := (Contrato."Grado ocupacion" / 100) * (DaysWorked / DaysOfMonth);
        END
        ELSE
          FTE := 0;
        
        */

        //... Se substituirá por el siguiente cálculo:

        FTE := 0;

        Contrato.Reset;
        Contrato.SetRange("No. empleado", EmployeeNo);
        Contrato.SetFilter("Fecha inicio", '..%1', ToDate);
        Contrato.SetFilter("Fecha finalización", '%1..|%2', FromDate, 0D);

        if Contrato.FindLast then begin

            DaysOfMonth := (ToDate - FromDate) + 1;
            lFechaInicioContratoAnterior := 0D;
            lStop := false;
            lContador := 0;

            repeat
                //... Viendo la existencia de contratos duplicados y confirmando que no se puede asumir que la fecha de finalizacion de un contrato
                //..  (cuando no se ha indicadosin este valor) deba ser la fecha anterior a la fecha de inicio del contrato siguiente,
                //... abortaremos la lectura de los contratos ante esta situacion.
                //... Es decir, sólo permitiremos que sea el último contrato, el que no tenga fecha de finalización asignada.
                lContador := lContador + 1;
                if (lContador > 1) and (Contrato."Fecha finalización" = 0D) then
                    lStop := true;

                if not lStop then begin
                    lFechaFinalizacion := Contrato."Fecha finalización";
                    if lFechaFinalizacion = 0D then begin
                        if lFechaInicioContratoAnterior = 0D then
                            lFechaFinalizacion := 99991231D
                        else
                            lFechaFinalizacion := lFechaInicioContratoAnterior - 1;
                    end
                    else begin
                        //... La siguiente comprobacion es para asegurarnos que los periodos de los contratos son contiguos y no hay intersecciones,
                        //... más alla del caso que la fecha de finalizacion del contrato no tenga valor.
                        if lFechaInicioContratoAnterior <> 0D then
                            if lFechaFinalizacion >= lFechaInicioContratoAnterior then
                                lFechaFinalizacion := lFechaInicioContratoAnterior - 1;
                    end;

                    lFechaInicioContratoAnterior := Contrato."Fecha inicio";

                    if lFechaFinalizacion >= FromDate then begin
                        DaysWorked := Date2DMY(ToDate, 1) - Date2DMY(FromDate, 1) + 1;

                        // si no se ha establecido el grado de ocupación, supondremos un 100%
                        if Contrato."Grado ocupacion" = 0 then
                            Contrato."Grado ocupacion" := 100;

                        if Contrato."Fecha inicio" > FromDate then
                            DaysWorked := DaysWorked - (Contrato."Fecha inicio" - FromDate);

                        if lFechaFinalizacion < ToDate then
                            DaysWorked := DaysWorked - (ToDate - lFechaFinalizacion);

                        FTE := FTE + ((Contrato."Grado ocupacion" / 100) * (DaysWorked / DaysOfMonth));
                    end
                    else
                        lStop := true;
                end;

            until (Contrato.Next(-1) = 0) or lStop;

            //... Aunque el código este depurado, si por un enlace incorrecto entre contratos se obtuviera un valor mayor que 1 para FTE, aplicamos este factor corrector.
            if FTE > 1 then
                FTE := 1;
        end;

        //-#265159

    end;

    local procedure GetEmployeeFTEOld(EmployeeNo: Code[20]; Fecha: Date) FTE: Decimal
    var
        Contrato: Record Contratos;
        FirstMonthDate: Date;
        LastMonthDate: Date;
        DaysOfMonth: Integer;
        DaysWorked: Integer;
    begin
        Contrato.SetRange("No. empleado", EmployeeNo);
        if Contrato.FindLast then begin
            if Contrato."Frecuencia de pago" = Contrato."Frecuencia de pago"::Quincenal then begin
                // Dia 1 o día 16
                if Date2DMY(Fecha, 1) = 1 then
                    FirstMonthDate := CalcDate('<-1M+15D>', Fecha)
                else
                    FirstMonthDate := CalcDate('<-CM>', Fecha);
            end
            else
                FirstMonthDate := CalcDate('<-1M>', Fecha);
            LastMonthDate := CalcDate('<-1D>', Fecha);
        end;

        Contrato.SetFilter("Fecha inicio", '..%1', LastMonthDate);
        Contrato.SetFilter("Fecha finalización", '%1..', FirstMonthDate);
        if not Contrato.FindLast then
            Contrato.SetRange("Fecha finalización", 0D);
        if Contrato.FindLast then begin
            // si no se ha establecido el grado de ocupación, supondremos un 100%
            if Contrato."Grado ocupacion" = 0 then
                Contrato."Grado ocupacion" := 100;

            DaysOfMonth := Date2DMY(CalcDate('<-1D+CM>', Fecha), 1);
            DaysWorked := Date2DMY(LastMonthDate, 1) - Date2DMY(FirstMonthDate, 1) + 1;
            if Contrato."Fecha inicio" > FirstMonthDate then
                DaysWorked := DaysWorked - (Contrato."Fecha inicio" - FirstMonthDate);
            if (Contrato."Fecha finalización" < LastMonthDate) and (Contrato."Fecha finalización" <> 0D) then
                DaysWorked := DaysWorked - (LastMonthDate - Contrato."Fecha finalización");
            FTE := (Contrato."Grado ocupacion" / 100) * (DaysWorked / DaysOfMonth);
        end
        else
            FTE := 0;
    end;


    procedure CeCoTipoInsert(): Integer
    begin
        exit(0);
    end;


    procedure CeCoTipoModify(): Integer
    begin
        exit(1);
    end;


    procedure CeCoTipoDelete(): Integer
    begin
        exit(2);
    end;


    procedure CeCoTipoRename(): Integer
    begin
        exit(3);
    end;


    procedure ConceptoProrrateado(PS: Record "Perfil Salarial"; Periodo: Date) Acumulado: Decimal
    var
        HistLinNom: Record "Historico Lin. nomina";
        ConceptosProrr: Record "Conceptos Salariales Provision";
        Fecha: Record Date;
        Empleado: Record Employee;
        ConfNomina: Record "Configuracion nominas";
        ConfContabilidad: Record "General Ledger Setup";
        /*  CalculoFechas: Codeunit "Funciones Nomina"; */
        Anos: Integer;
        Meses: Integer;
        Dias: Integer;
        CantEmpl: Integer;
        DiasVacaciones: Decimal;
        MontoVacaciones: Decimal;
        Diastxt: Text[30];
        FIni: Date;
        Acumulado2: Decimal;
        Err001: Label 'Configure %1 to %2 %3';
        Inicial: Date;
        Final: Date;
    begin
        Empleado.Get(PS."No. empleado");
        ConceptosProrr.SetRange(Código, PS."Concepto salarial");
        ConfNomina.Get;
        Inicial := Periodo;
        Final := Periodo;

        if ConceptosProrr.FindSet then
            repeat
                Acumulado := 0;
                Clear(HistLinNom);
                HistLinNom.Reset;
                HistLinNom.SetCurrentKey("No. empleado", "Tipo concepto", Período, "Concepto salarial");
                HistLinNom.SetRange("No. empleado", PS."No. empleado");
                HistLinNom.SetRange(Período, Periodo);
                HistLinNom.SetRange("Concepto salarial", ConceptosProrr.Código);
                if HistLinNom.FindSet then
                    repeat
                        Acumulado += HistLinNom.Total;
                    until HistLinNom.Next = 0;

                Empleado.Salario := 0;
                Clear(HistLinNom);
                HistLinNom.Reset;
                HistLinNom.SetCurrentKey("No. empleado", "Tipo concepto", Período, "Concepto salarial");
                HistLinNom.SetRange("No. empleado", PS."No. empleado");
                HistLinNom.SetRange(Período, Periodo);
                HistLinNom.SetRange("Concepto salarial", ConceptosProrr.Código);
                HistLinNom.SetRange("Salario Base", true);
                if HistLinNom.FindSet then
                    repeat
                        Empleado.Salario += HistLinNom.Total;
                    until HistLinNom.Next = 0;

                Acumulado /= 12;
                case ConfNomina."Nomina de Pais" of
                    'BO':
                        begin
                            if Empleado."Employment Date" = 0D then
                                Error(Err001, Empleado.FieldCaption("Employment Date"), Empleado.TableCaption, Empleado."No.");

                            /*    CalculoFechas.CalculoEntreFechas(Empleado."Employment Date", Final, Anos, Meses, Dias); */

                            if ConfNomina."Concepto Incentivos" = ConceptosProrr.Código then begin
                                Empleado.Salario := 0;
                                Acumulado2 := 0;

                                //Se busca el acumulado de los 3 ultimos meses
                                FIni := DMY2Date(1, Date2DMY(CalcDate('-3M', Periodo), 2), Date2DMY(CalcDate('-3M', Periodo), 3));
                                Clear(HistLinNom);
                                HistLinNom.Reset;
                                HistLinNom.SetCurrentKey("No. empleado", "Tipo concepto", Período, "Concepto salarial");
                                HistLinNom.SetRange("No. empleado", PS."No. empleado");
                                HistLinNom.SetRange(Período, FIni, CalcDate('-1D', Periodo));
                                HistLinNom.SetRange("Aplica para Regalia", true);
                                //        MESSAGE('%1',HistLinNom.GETFILTERS);
                                if HistLinNom.FindSet then
                                    repeat
                                        Empleado.Salario += HistLinNom.Total;
                                    until HistLinNom.Next = 0;

                                //Se calculan los dias transcurridos al presente periodo y hasta el mes anterior
                                if Empleado."Fecha despues quinquenios" <> 0D then begin
                                    DiasVacaciones := Final - Empleado."Fecha despues quinquenios";
                                    Dias := CalcDate('-1D', Inicial) - Empleado."Fecha despues quinquenios";
                                end
                                else begin
                                    DiasVacaciones := Final - Empleado."Employment Date";
                                    Dias := CalcDate('-1D', Inicial) - Empleado."Employment Date";
                                end;

                                //Salario promedio de los ultimos 3 meses
                                Empleado.Salario /= 3;

                                //Importe de Indemnización acumulada actual
                                MontoVacaciones := Round((Empleado.Salario * Dias / 365), 0.01);
                                //        error('%1\ %2\ %3\ %4\ %5',empleado.salario,diasvacaciones,montovacaciones,final,Empleado."Employment Date");
                                //Importe de Indemnización acumulada mes anterior

                                FIni := DMY2Date(1, Date2DMY(CalcDate('-2M', Inicial), 2), Date2DMY(CalcDate('-2M', Inicial), 3));
                                Clear(HistLinNom);
                                Clear(Empleado.Salario);
                                HistLinNom.SetCurrentKey("No. empleado", "Tipo concepto", Período, "Concepto salarial");
                                HistLinNom.SetRange("No. empleado", PS."No. empleado");
                                HistLinNom.SetRange(Período, FIni, Final);
                                HistLinNom.SetRange("Aplica para Regalia", true);
                                //        message('%1',histlinnom.getfilters);
                                if HistLinNom.FindSet then
                                    repeat
                                        Empleado.Salario += HistLinNom.Total;
                                    until HistLinNom.Next = 0;

                                //Salario promedio de los ultimos 3 meses
                                Empleado.Salario /= 3;

                                Acumulado2 := Round((Empleado.Salario * DiasVacaciones / 365), 0.01);

                                Acumulado := Round(Acumulado2 - MontoVacaciones, 0.01);
                                //        ERROR('aa%1 %2 %3 %4',Acumulado,Acumulado2,MontoVacaciones);
                                //message('Ind %1 %2 %3 %4 %5',acumulado,montovacaciones,acumulado2,DIAS,DIASVACACIONES);
                            end
                            else
                                if ConfNomina."Concepto Regalia" = ConceptosProrr.Código then begin
                                    Empleado.Salario := 0;
                                    Acumulado2 := 0;

                                    //Se busca el acumulado de los 3 ultimos meses
                                    FIni := DMY2Date(1, Date2DMY(CalcDate('-3M', Periodo), 2), Date2DMY(CalcDate('-3M', Periodo), 3));
                                    Clear(HistLinNom);
                                    HistLinNom.Reset;
                                    HistLinNom.SetCurrentKey("No. empleado", "Tipo concepto", Período, "Concepto salarial");
                                    HistLinNom.SetRange("No. empleado", PS."No. empleado");
                                    HistLinNom.SetRange(Período, FIni, CalcDate('-1D', Periodo));
                                    HistLinNom.SetRange("Aplica para Regalia", true);
                                    if HistLinNom.FindSet then
                                        repeat
                                            Empleado.Salario += HistLinNom.Total;
                                        until HistLinNom.Next = 0;

                                    //Se calculan los dias transcurridos al presente periodo y hasta el mes anterior

                                    if Anos <> 0 then begin
                                        DiasVacaciones := Final - DMY2Date(1, 1, Date2DMY(Final, 3));
                                        Dias := CalcDate('-1D', Inicial) - DMY2Date(1, 1, Date2DMY(Final, 3));
                                    end
                                    else begin
                                        DiasVacaciones := Final - DMY2Date(1, Date2DMY(Empleado."Employment Date", 2), Date2DMY(Empleado."Employment Date", 3));
                                        Dias := CalcDate('-1D', Inicial) - DMY2Date(1, Date2DMY(Empleado."Employment Date", 2),
                                                          Date2DMY(Empleado."Employment Date", 3));
                                    end;

                                    //Salario promedio de los ultimos 3 meses
                                    Empleado.Salario /= 3;

                                    //Importe de regalia acumulada actual
                                    MontoVacaciones := Round((Empleado.Salario * Dias / 365), 0.01);

                                    //Importe de regalia acumulada mes anterior

                                    FIni := DMY2Date(1, Date2DMY(CalcDate('-2M', Periodo), 2),
                                                      Date2DMY(CalcDate('-2M', Periodo), 3));

                                    Clear(HistLinNom);
                                    Clear(Empleado.Salario);
                                    HistLinNom.SetCurrentKey("No. empleado", "Tipo concepto", Período, "Concepto salarial");
                                    HistLinNom.SetRange("No. empleado", PS."No. empleado");
                                    HistLinNom.SetRange(Período, FIni, Final);
                                    HistLinNom.SetRange("Aplica para Regalia", true);
                                    if HistLinNom.FindSet then
                                        repeat
                                            Empleado.Salario += HistLinNom.Total;
                                        until HistLinNom.Next = 0;

                                    //Salario promedio de los ultimos 3 meses
                                    Empleado.Salario /= 3;
                                    Acumulado2 := Round((Empleado.Salario * DiasVacaciones / 365), 0.01);

                                    Acumulado := Round(Acumulado2 - MontoVacaciones, 0.01);

                                    //        ERROR('bb %1 %2 %3 %4 %5',Acumulado,MontoVacaciones,Acumulado2,Dias,DiasVacaciones);
                                    //        message('reg %1 %2 %3 %4 %5',acumulado,montovacaciones,acumulado2,DIAS,DIASVACACIONES);
                                end;
                        end;
                    'DO':
                        begin
                            if ConfNomina."Concepto Vacaciones" = ConceptosProrr.Disponible then begin
                                if Empleado."Employment Date" = 0D then
                                    Error(Err001, Empleado.FieldCaption("Employment Date"), Empleado.TableCaption, Empleado."No.");

                                /*   DiasVacaciones := CalculoFechas.CalculoDiaVacaciones(Empleado."No.", Date2DMY(Empleado."Employment Date", 2), Date2DMY(WorkDate, 3), MontoVacaciones,
                                                                                       Empleado."Employment Date", Empleado."Fecha salida empresa"); */

                                Empleado.Salario /= 23.83;
                                MontoVacaciones := (Empleado.Salario * DiasVacaciones) / 12;
                                Acumulado := MontoVacaciones;
                            end
                            else
                                if ConfNomina."Concepto Bonificacion" = ConceptosProrr.Disponible then begin
                                    if Empleado."Employment Date" = 0D then
                                        Error(Err001, Empleado.FieldCaption("Employment Date"), Empleado.TableCaption, Empleado."No.");

                                    /*   DiasVacaciones := CalculoFechas.CalculoDiaVacaciones(Empleado."No.", Date2DMY(Empleado."Employment Date", 2), Date2DMY(WorkDate, 3), MontoVacaciones,
                                                                                           Empleado."Employment Date", Empleado."Fecha salida empresa");
                                      Empleado.Salario /= 23.83;
                                      MontoVacaciones := (Empleado.Salario * DiasVacaciones) / 12;
                                      Acumulado := MontoVacaciones; */
                                end;
                        end;

                    'GT':
                        begin
                            case ConceptosProrr."Tipo provision" of
                                0:
                                    ; //Variable
                                1:
                                    ; //Fijo
                                2: //Fórmula
                                    begin
                                        PS.Validate("Formula calculo", ConceptosProrr."Fórmula cálculo");
                                        Acumulado := PS.Importe;
                                    end;
                            end;
                        end;
                    'EC':
                        begin
                            case ConceptosProrr."Tipo provision" of
                                0: //Variable
                                    begin
                                        if Empleado."Fin contrato" <> 0D then begin
                                            if (((Date2DMY(Empleado."Employment Date", 2) = Date2DMY(Periodo, 2)) and
                                                 (Date2DMY(Empleado."Employment Date", 3) = Date2DMY(Periodo, 3)))) and
                                               (((Date2DMY(Empleado."Fin contrato", 2) = Date2DMY(Periodo, 2)) and
                                                 (Date2DMY(Empleado."Fin contrato", 3) = Date2DMY(Periodo, 3)))) then begin
                                                /*      CalculoFechas.CalculoEntreFechas(Empleado."Employment Date", Empleado."Fin contrato", Anos, Meses, Dias); */
                                                Evaluate(PS.Importe, ConceptosProrr."Fórmula cálculo");
                                                Acumulado := Round((PS.Importe / 30) * Dias, ConfContabilidad."Amount Rounding Precision");
                                            end
                                            else
                                                if (((Date2DMY(Empleado."Fin contrato", 2) = Date2DMY(Periodo, 2)) and
                                                     (Date2DMY(Empleado."Fin contrato", 3) = Date2DMY(Periodo, 3)))) and
                                                     (Empleado."Fin contrato" <> 0D) then begin
                                                    Dias := Date2DMY(Empleado."Fin contrato", 1);
                                                    if Date2DMY(Periodo, 2) = 2 then
                                                        Dias := 30 - Dias;

                                                    Evaluate(PS.Importe, ConceptosProrr."Fórmula cálculo");
                                                    Acumulado := Round((PS.Importe / 30) * Dias, ConfContabilidad."Amount Rounding Precision");
                                                end;
                                        end
                                        else
                                            if (((Date2DMY(Empleado."Employment Date", 2) = Date2DMY(Periodo, 2)) and
                                                 (Date2DMY(Empleado."Employment Date", 3) = Date2DMY(Periodo, 3)) and
                                                 (Empleado."Fin contrato" = 0D))) then begin
                                                Dias := Date2DMY(Empleado."Employment Date", 1);
                                                if Date2DMY(Periodo, 2) = 2 then
                                                    Dias := 30 - Dias;

                                                Evaluate(PS.Importe, ConceptosProrr."Fórmula cálculo");
                                                Acumulado := Round((PS.Importe / 30) * Dias, ConfContabilidad."Amount Rounding Precision");
                                            end;
                                    end;

                                1: //Fijo
                                    begin
                                        if Empleado."Fin contrato" <> 0D then begin
                                            if (((Date2DMY(Empleado."Employment Date", 2) = Date2DMY(Periodo, 2)) and
                                                 (Date2DMY(Empleado."Employment Date", 3) = Date2DMY(Periodo, 3)))) and
                                               (((Date2DMY(Empleado."Fin contrato", 2) = Date2DMY(Periodo, 2)) and
                                                 (Date2DMY(Empleado."Fin contrato", 3) = Date2DMY(Periodo, 3)))) then begin
                                                /*  CalculoFechas.CalculoEntreFechas(Empleado."Employment Date", Empleado."Fin contrato", Anos, Meses, Dias); */
                                                Evaluate(PS.Importe, ConceptosProrr."Fórmula cálculo");
                                                Acumulado := Round((PS.Importe / 30) * Dias, ConfContabilidad."Amount Rounding Precision");
                                            end
                                            else
                                                if (((Date2DMY(Empleado."Fin contrato", 2) = Date2DMY(Periodo, 2)) and
                                                     (Date2DMY(Empleado."Fin contrato", 3) = Date2DMY(Periodo, 3)))) and
                                                     (Empleado."Fin contrato" <> 0D) then begin
                                                    Dias := Date2DMY(Empleado."Fin contrato", 1);
                                                    if Date2DMY(Periodo, 2) = 2 then
                                                        Dias := 30 - Dias + 1;

                                                    Evaluate(PS.Importe, ConceptosProrr."Fórmula cálculo");
                                                    Acumulado := Round((PS.Importe / 30) * Dias, ConfContabilidad."Amount Rounding Precision");
                                                end;
                                        end
                                        else
                                            if (((Date2DMY(Empleado."Employment Date", 2) = Date2DMY(Periodo, 2)) and
                                                 (Date2DMY(Empleado."Employment Date", 3) = Date2DMY(Periodo, 3)) and
                                                 (Empleado."Fin contrato" = 0D))) then begin
                                                Dias := Date2DMY(Empleado."Employment Date", 1);
                                                //             IF DATE2DMY(periodo,2) = 2 THEN
                                                Dias := 30 - Dias + 1;

                                                Evaluate(PS.Importe, ConceptosProrr."Fórmula cálculo");
                                                Acumulado := Round((PS.Importe / 30) * Dias, ConfContabilidad."Amount Rounding Precision");
                                            end
                                            else begin
                                                Evaluate(Acumulado, ConceptosProrr."Fórmula cálculo");
                                            end;
                                        //            message('%1 %2 %3 %4 %5',dias,Empleado."Employment Date",periodo);
                                    end;
                                2: //Fórmula
                                    begin
                                        PS.Validate("Formula calculo", ConceptosProrr."Fórmula cálculo");
                                        Acumulado := PS.Importe;
                                    end;
                            end;
                        end;
                    'PY':
                        begin
                            case ConceptosProrr."Tipo provision" of
                                0:
                                    ; //Variable
                                1:
                                    ; //Fijo
                                2: //Fórmula
                                    begin
                                        PS.Validate("Formula calculo", ConceptosProrr."Fórmula cálculo");
                                        Acumulado := PS.Importe;
                                    end;
                            end;
                        end;
                    'HN':
                        begin
                            case ConceptosProrr."Tipo provision" of
                                0:
                                    ; //Variable
                                1:
                                    ; //Fijo
                                2: //Fórmula
                                    begin
                                        PS.Validate("Formula calculo", ConceptosProrr."Fórmula cálculo");
                                        Acumulado := PS.Importe;
                                    end;
                            end;
                        end;
                end;

            until ConceptosProrr.Next = 0;
    end;

    /*    trigger XmlDoc::NodeInserting(sender: Variant; e: DotNet XmlNodeChangedEventArgs)
       begin
       end;

       trigger XmlDoc::NodeInserted(sender: Variant; e: DotNet XmlNodeChangedEventArgs)
       begin
       end;

       trigger XmlDoc::NodeRemoving(sender: Variant; e: DotNet XmlNodeChangedEventArgs)
       begin
       end;

       trigger XmlDoc::NodeRemoved(sender: Variant; e: DotNet XmlNodeChangedEventArgs)
       begin
       end;

       trigger XmlDoc::NodeChanging(sender: Variant; e: DotNet XmlNodeChangedEventArgs)
       begin
       end;

       trigger XmlDoc::NodeChanged(sender: Variant; e: DotNet XmlNodeChangedEventArgs)
       begin
       end; */
}

