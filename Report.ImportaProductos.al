report 55041 "Importa Productos"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Integer"; "Integer")
        {

            trigger OnAfterGetRecord()
            var
                wDateTime: DateTime;
            begin

                repeat
                    case (rExcelBuffer.xlColID) of
                        'A':
                            begin
                                NoLine += 10000;
                                rWHJnlLine.Init;
                                rWHJnlLine.Validate("Journal Template Name", wDiario);
                                rWHJnlLine.Validate("Journal Batch Name", wSeccion);
                                rWHJnlLine.Validate("Location Code", wAlm);
                                rWHJnlLine.Validate("Line No.", NoLine);
                                Evaluate(wDateTime, rExcelBuffer."Cell Value as Text");
                                wFec := DT2Date(wDateTime);
                                rWHJnlLine.Validate(rWHJnlLine."Registering Date", wFec);
                                CompletaLinea(wCont = 0);
                            end;
                        'B':
                            begin
                                case rExcelBuffer."Cell Value as Text" of
                                    'Ajuste negativo':
                                        rWHJnlLine.Validate("Entry Type", rWHJnlLine."Entry Type"::"Negative Adjmt.");
                                    'Ajuste positivo':
                                        rWHJnlLine.Validate("Entry Type", rWHJnlLine."Entry Type"::"Positive Adjmt.");
                                    'Movimiento':
                                        rWHJnlLine.Validate("Entry Type", rWHJnlLine."Entry Type"::Movement);
                                end;
                            end;
                        //'C' : rWHJnlLine.VALIDATE(rWHJnlLine."Whse. Document No." ,  rExcelBuffer."Cell Value as Text");
                        'D':
                            rWHJnlLine.Validate("Item No.", rExcelBuffer."Cell Value as Text");
                        'E':
                            begin
                                if rExcelBuffer."Cell Value as Text" <> wAlm then
                                    Error(Err001, wAlm);
                            end;
                        //'F' : rWHJnlLine.VALIDATE(Description, rExcelBuffer."Cell Value as Text");
                        'G':
                            rWHJnlLine.Validate("Zone Code", rExcelBuffer."Cell Value as Text");
                        'H':
                            rWHJnlLine.Validate("Bin Code", rExcelBuffer."Cell Value as Text");
                        'I':
                            begin
                                Evaluate(rWHJnlLine.Quantity, rExcelBuffer."Cell Value as Text");
                                rWHJnlLine.Validate(Quantity);

                                if rWHJnlLine.Quantity < 0 then
                                    ExchangeFromToBin;
                                rWHJnlLine.Insert(true);
                                Clear(wZona);
                                Clear(wUbic);

                                wCont += 1;
                            end;
                    end;
                until rExcelBuffer.Next = 0;
            end;

            trigger OnPostDataItem()
            begin

                Message(Format(wCont) + ' líneas importadas');
            end;

            trigger OnPreDataItem()
            begin

                rExcelBuffer.DeleteAll;
                rExcelBuffer.SetCurrentKey("Row No.", "Column No.");
                /*             rExcelBuffer.OpenBook(FileName, Sheetname); */
                rExcelBuffer.ReadSheet();
                if wCabecera then
                    rExcelBuffer.SetFilter("Row No.", '>%1', 1);
                rExcelBuffer.SetRange(rExcelBuffer."Column No.", 1, 9);
                if not rExcelBuffer.FindSet then
                    CurrReport.Break;

                Clear(NoLine);
                rWHJnlLine.SetRange(rWHJnlLine."Journal Template Name", wDiario);
                rWHJnlLine.SetRange(rWHJnlLine."Journal Batch Name", wSeccion);
                rWHJnlLine.SetRange(rWHJnlLine."Location Code", wAlm);
                if rWHJnlLine.FindLast then
                    NoLine := rWHJnlLine."Line No.";

                Clear(wCont);
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

    var
        rExcelBuffer: Record "Excel Buffer" temporary;
        FileName: Text[1024];
        Sheetname: Text[1024];
        CommonDialogMgt: Codeunit "File Management";
        wSeccion: Code[20];
        rWHJnlLine: Record "Warehouse Journal Line";
        NoLine: Integer;
        wDiario: Code[20];
        wCabecera: Boolean;
        wFec: Date;
        wCont: Integer;
        wAlm: Code[20];
        wDoc: Code[20];
        Bin: Record Bin;
        WhseJnlBatch: Record "Warehouse Journal Batch";
        WhseJnlTemplate: Record "Warehouse Journal Template";
        NoSeriesMgt: Codeunit "No. Series";
        Location: Record Location;
        wZona: Code[20];
        wUbic: Code[20];
        Text002: Label 'Update Workbook';
        Text000: Label 'Analyzing Data...\\';
        Text001: Label 'Proceso finalizado.';
        Err001: Label 'Se esperaba recibir líneas del Almacen %1';


    procedure RecibeSeccion(parSeccion: Code[20]; parDiario: Code[20]; parAlmacen: Code[20])
    begin
        wSeccion := parSeccion;
        wDiario := parDiario;
        wAlm := parAlmacen;
    end;


    procedure CompletaLinea(PrimeraLinea: Boolean)
    begin


        WhseJnlTemplate.Get(rWHJnlLine."Journal Template Name");
        WhseJnlBatch.Get(rWHJnlLine."Journal Template Name", rWHJnlLine."Journal Batch Name", rWHJnlLine."Location Code");
        if PrimeraLinea then begin
            if WhseJnlBatch."No. Series" <> '' then begin
                Clear(NoSeriesMgt);
                rWHJnlLine."Whse. Document No." :=
                  NoSeriesMgt.GetNextNo(WhseJnlBatch."No. Series", rWHJnlLine."Registering Date");
                wDoc := rWHJnlLine."Whse. Document No.";
            end;
        end
        else
            rWHJnlLine."Whse. Document No." := wDoc;

        if WhseJnlTemplate.Type = WhseJnlTemplate.Type::"Physical Inventory" then begin
            rWHJnlLine."Source Document" := rWHJnlLine."Source Document"::"Phys. Invt. Jnl.";
            rWHJnlLine."Whse. Document Type" := rWHJnlLine."Whse. Document Type"::"Whse. Phys. Inventory";
        end;
        rWHJnlLine."Source Code" := WhseJnlTemplate."Source Code";
        rWHJnlLine."Reason Code" := WhseJnlBatch."Reason Code";
        rWHJnlLine."Registering No. Series" := WhseJnlBatch."Registering No. Series";
        Location.Get(rWHJnlLine."Location Code");
        if WhseJnlTemplate.Type <> WhseJnlTemplate.Type::Reclassification then begin
            if rWHJnlLine.Quantity >= 0 then
                rWHJnlLine."Entry Type" := rWHJnlLine."Entry Type"::"Positive Adjmt."
            else
                rWHJnlLine."Entry Type" := rWHJnlLine."Entry Type"::"Negative Adjmt.";
            GetBin(Location.Code, Location."Adjustment Bin Code");
            rWHJnlLine."From Zone Code" := Bin."Zone Code";
            rWHJnlLine."From Bin Code" := Bin.Code;
            rWHJnlLine."From Bin Type Code" := Bin."Bin Type Code";
        end else
            rWHJnlLine."Entry Type" := rWHJnlLine."Entry Type"::Movement;
    end;

    local procedure GetBin(LocationCode: Code[10]; BinCode: Code[20])
    begin
        if (LocationCode = '') or (BinCode = '') then
            Bin.Init
        else
            if (Bin."Location Code" <> LocationCode) or
               (Bin.Code <> BinCode)
            then
                Bin.Get(LocationCode, BinCode);
    end;

    local procedure ExchangeFromToBin()
    var
        WhseJnlLine: Record "Warehouse Journal Line";
    begin
        WhseJnlLine := rWHJnlLine;
        rWHJnlLine."From Zone Code" := WhseJnlLine."To Zone Code";
        rWHJnlLine."From Bin Code" := WhseJnlLine."To Bin Code";
        rWHJnlLine."From Bin Type Code" :=
          GetBinType(rWHJnlLine."Location Code", rWHJnlLine."From Bin Code");

        rWHJnlLine."To Zone Code" := WhseJnlLine."From Zone Code";
        rWHJnlLine."To Bin Code" := WhseJnlLine."From Bin Code";
    end;

    local procedure GetBinType(LocationCode: Code[10]; BinCode: Code[20]): Code[10]
    var
        BinType: Record "Bin Type";
    begin
        GetBin(LocationCode, BinCode);
        WhseJnlTemplate.Get(rWHJnlLine."Journal Template Name");
        if WhseJnlTemplate.Type = WhseJnlTemplate.Type::Reclassification then
            if Bin."Bin Type Code" <> '' then
                if BinType.Get(Bin."Bin Type Code") then
                    BinType.TestField(Receive, false);

        exit(Bin."Bin Type Code");
    end;
}

