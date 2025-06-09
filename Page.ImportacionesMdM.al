page 75016 "Importaciones MdM"
{
    ApplicationArea = all;
    //ApplicationArea = Basic, Suite, Service;
    Caption = 'MdM Imports';
    CardPageID = "Imp.MdM Cabecera";
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Imp.MdM Cabecera";
    SourceTableView = SORTING(Id)
                      ORDER(Descending);
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Id; rec.Id)
                {
                }
                field(Estado; rec.Estado)
                {
                }
                field("Estado Envio"; rec."Estado Envio")
                {
                }
                field(Operacion; rec.Operacion)
                {
                }
                field("Fecha Creacion"; rec."Fecha Creacion")
                {
                }
                field(id_mensaje; rec.id_mensaje)
                {
                }
                field(sistema_origen; rec.sistema_origen)
                {
                }
                field(pais_origen; rec.pais_origen)
                {
                }
                field(fecha_origen; rec.fecha_origen)
                {
                }
                field(fecha; rec.fecha)
                {
                }
                field(tipo; rec.tipo)
                {
                }
                field(Control1000000012; rec.Entrada) // Agregado rec.
                {
                }
                field(Traspasado; rec.Traspasado)
                {
                    Visible = false;
                }
                field(Attempt; rec.Attempt)
                {
                }
                field("Texto Error"; rec."Texto Error")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Action1000000014)
            {
                group("Imp. Excel")
                {
                    Image = Excel;
                    action("Selecc Hoja")
                    {
                        Image = ImportExcel;

                        trigger OnAction()
                        begin
                            cImpExcel.ImportaFile(false, 0);
                        end;
                    }
                    action("Todas las Hojas")
                    {
                        Image = ImportExcel;

                        trigger OnAction()
                        begin
                            cImpExcel.ImportaFile(true, 0);
                        end;
                    }
                }
                group("Exportación XML")
                {
                    Caption = 'Exportación XML';
                    Image = XMLFile;
                    action(Exportar)
                    {
                        Caption = 'Exportar';
                        Image = CreateXMLFile;
                        RunObject = XMLport "MDM-Migracion Inicial Art.";
                    }
                }
                group(Guardar)
                {
                    Caption = 'Save';
                    Image = Save;
                    action(Entrada)
                    {
                        Caption = 'Entrada';
                        Enabled = wBlobEnabled1;
                        Image = Save;

                        trigger OnAction()
                        var
                            TempBlob: Codeunit "Temp Blob";
                            InStream: InStream;
                        begin
                            rec.CalcFields(DOC);
                            if not rec.DOC.HasValue then
                                exit;

                            rec.DOC.CreateInStream(InStream);
                            TempBlob.CreateOutStream().Write(InStream);

                            cFileMng.BLOBExport(TempBlob, 'DOC.xml', true);
                        end;
                    }
                    action(Salida)
                    {
                        Caption = 'Salida';
                        Enabled = wBlobEnabled2;
                        Image = Save;

                        trigger OnAction()
                        var
                            TempBlob: Codeunit "Temp Blob";
                            InStream: InStream;
                        begin
                            rec.CalcFields("Send XML");
                            if not rec."Send XML".HasValue then
                                exit;

                            rec."Send XML".CreateInStream(InStream);
                            TempBlob.CreateOutStream().Write(InStream);

                            cFileMng.BLOBExport(TempBlob, 'SendDOC.xml', true);
                        end;
                    }
                    action("Resp. Salida")
                    {
                        Caption = 'Resp. Salida';
                        Enabled = wBlobEnabled3;
                        Image = Save;

                        trigger OnAction()
                        var
                            TempBlob: Codeunit "Temp Blob";
                            InStream: InStream;
                        begin
                            rec.CalcFields("Send XML Reply");
                            if not rec."Send XML Reply".HasValue then
                                exit;

                            rec."Send XML Reply".CreateInStream(InStream);
                            TempBlob.CreateOutStream().Write(InStream);

                            cFileMng.BLOBExport(TempBlob, 'SendResp.xml', true);
                        end;
                    }
                }
                action(Traspasar)
                {
                    Caption = 'Traspasar';
                    Image = Open;

                    trigger OnAction()
                    var
                        lrCab: Record "Imp.MdM Cabecera";
                    begin

                        CurrPage.SetSelectionFilter(lrCab);
                        if lrCab.FindSet then begin
                            repeat
                                cMaestrosMdm.TrasPasaCab(lrCab);
                            until lrCab.Next = 0;
                        end;
                        //cMaestrosMdm.TrasPasaCab(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        rec.CalcFields(DOC, "Send XML", "Send XML Reply");
        wBlobEnabled1 := rec.DOC.HasValue;
        wBlobEnabled2 := rec."Send XML".HasValue;
        wBlobEnabled3 := rec."Send XML Reply".HasValue;
    end;

    var
        cImpExcel: Codeunit "Imp Excel MdM";
        cMaestrosMdm: Codeunit "Gest. Maestros MdM";
        cFileMng: Codeunit "File Management";
        wBlobEnabled1: Boolean;
        wBlobEnabled2: Boolean;
        wBlobEnabled3: Boolean;
}