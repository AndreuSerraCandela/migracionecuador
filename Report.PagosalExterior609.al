report 76057 "Pagos al Exterior (609)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './PagosalExterior609.rdlc';

    dataset
    {
        dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
        {
            RequestFilterFields = "Vendor No.", "Posting Date", "Vendor Posting Group", "Bal. Account Type", "Bal. Account No.", "Currency Code";

            trigger OnAfterGetRecord()
            begin
                /*
                ImporteBase  := 0;
                ImporteTotal := 0;
                ImporteITBIS := 0;
                "%ITBIS"     := 0;
                ISRRetenido := 0;
                OtrasRetenciones := 0;
                
                
                GLE.RESET;
                GLE.SETRANGE("G/L Account No.",CtasRetencionISR);
                GLE.SETRANGE("Posting Date","Posting Date");
                GLE.SETRANGE("Document Type",GLE."Document Type"::Payment);
                GLE.SETRANGE("Document No.","Document No.");
                GLE.SETRANGE(GLE."Reason Code",ReasonCodes.Code);
                IF GLE.FIND('-') THEN
                  REPEAT
                    ISRRetenido += ABS(GLE.Amount);
                  UNTIL GLE.NEXT = 0;
                
                {
                //AMS-Buscamos la dimension de Costos y Gastos de la linea de mayor importe
                PIL1.RESET;
                PIL1.SETCURRENTKEY("Document No.","Amount Including VAT");
                PIL1.SETRANGE("Document No.","Document No.");
                IF PIL1.FIND('+') THEN
                 BEGIN
                    rDocDimension.RESET;
                    rDocDimension.SETRANGE("Document No.",PIL1."Document No.");
                    rDocDimension.SETRANGE("Dimension Code",DimClasifGasto);
                    rDocDimension.SETRANGE("Line No.",PIL1."Line No.");
                
                    IF rDocDimension.FIND('-') THEN
                      txtCostosGastos := rDocDimension."Dimension Value Code";
                 END;
                }
                
                rMovITBIS.SETCURRENTKEY("Document No.","Posting Date");
                rMovITBIS.SETRANGE("Document No.","Document No.");
                rMovITBIS.SETRANGE("Posting Date","Posting Date");
                IF rMovITBIS.FIND('-') THEN
                   REPEAT
                     IF rMovITBIS.Amount <> 0 THEN
                        ImporteGravado += ABS(rMovITBIS.Base)
                     ELSE
                        ImporteExento  += ABS(rMovITBIS.Base);
                
                     ImporteITBIS      += rMovITBIS.Amount
                   UNTIL rMovITBIS.NEXT = 0;
                
                ImporteBase += "Original Amt. (LCY)";
                
                ImporteTotal   := "Original Amt. (LCY)";
                
                IF NOT rProveedor.GET("Vendor No.") THEN
                   rProveedor.INIT;
                */

            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        InfoEmpresa.Get;
        DirEmpresa[1] := InfoEmpresa.Name;
        DirEmpresa[2] := InfoEmpresa."Name 2";
        DirEmpresa[3] := InfoEmpresa.Address;
        DirEmpresa[4] := InfoEmpresa."Address 2";
        DirEmpresa[5] := InfoEmpresa.City;
        DirEmpresa[6] := InfoEmpresa."Post Code" + ' ' + InfoEmpresa.County;
        DirEmpresa[7] := txt001 + InfoEmpresa."VAT Registration No.";
        CompressArray(DirEmpresa);

        ArchITBIS.Reset;
        ArchITBIS.SetRange("Codigo reporte", '609');
        ArchITBIS.DeleteAll;
    end;

    var
        InfoEmpresa: Record "Company Information";
        DirEmpresa: array[7] of Text[50];
        ArchITBIS: Record "Archivo Transferencia ITBIS";
        txt001: Label 'RNC/Cédula ';
        ImporteBase: Decimal;
        "%ITBIS": Decimal;
        ImporteITBIS: Decimal;
        ImporteGravado: Decimal;
        ImporteExento: Decimal;
        ImporteTotal: Decimal;
        ImporteGpo: Decimal;
        DebeGpo: Decimal;
        HaberGpo: Decimal;
        ISRRetenido: Decimal;
        CtasRetencionISR: Code[30];
        OtrasRetenciones: Decimal;
        ReasonCodes: Record "Reason Code";
        GLE: Record "G/L Entry";
        PIL1: Record "Purch. Inv. Line";
}

