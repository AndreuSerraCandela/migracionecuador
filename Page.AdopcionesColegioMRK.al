#pragma implicitwith disable
page 76082 "Adopciones - Colegio - MRK"
{
    ApplicationArea = all;
    Caption = 'School - Adoptions';
    DataCaptionFields = "Cod. Colegio", "Cod. Docente";
    PageType = Card;
    SourceTable = "Ranking CVM";
    SourceTableView = SORTING("Cod. Docente", "Cod. Colegio", "Cod. Local", "Cod. Producto");

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Cod. Producto"; Rec."Cod. Producto")
                {
                    Editable = false;
                }
                field("Descripción producto"; Rec."Descripción producto")
                {
                    Editable = false;
                }
                field("Edicion Coleccion"; Rec."Edicion Coleccion")
                {
                }
                field(t2INI; t2INI)
                {
                    AssistEdit = true;
                    Caption = '2INI';
                    Editable = false;

                    trigger OnAssistEdit()
                    begin
                        if Rec."Marca Adopcion - 2INI" = Rec."Adopcion - 2INI" then
                            Rec."Marca Adopcion - 2INI" := 0
                        else
                            Rec."Marca Adopcion - 2INI" := Rec."Adopcion - 2INI";
                    end;
                }
                field("Marca Adopcion - 2INI"; Rec."Marca Adopcion - 2INI")
                {
                    Editable = false;
                }
                field(t3INI; t3INI)
                {
                    Caption = '3INI';
                    Editable = false;

                    trigger OnAssistEdit()
                    begin
                        if Rec."Marca Adopcion - 3INI" = Rec."Adopcion - 3INI" then
                            Rec."Marca Adopcion - 3INI" := 0
                        else
                            Rec."Marca Adopcion - 3INI" := Rec."Adopcion - 3INI";
                    end;
                }
                field("Marca Adopcion - 3INI"; Rec."Marca Adopcion - 3INI")
                {
                    Editable = false;
                }
                field(t4INI; t4INI)
                {
                    Caption = '4INI';
                    Editable = false;

                    trigger OnAssistEdit()
                    begin
                        if Rec."Marca Adopcion - 4INI" = Rec."Adopcion - 4INI" then
                            Rec."Marca Adopcion - 4INI" := 0
                        else
                            Rec."Marca Adopcion - 4INI" := Rec."Adopcion - 4INI";
                    end;
                }
                field("Marca Adopcion - 4INI"; Rec."Marca Adopcion - 4INI")
                {
                    Editable = false;
                }
                field(t5INI; t5INI)
                {
                    Caption = '5INI';
                    Editable = false;

                    trigger OnAssistEdit()
                    begin
                        if Rec."Marca Adopcion - 5INI" = Rec."Adopcion - 5INI" then
                            Rec."Marca Adopcion - 5INI" := 0
                        else
                            Rec."Marca Adopcion - 5INI" := Rec."Adopcion - 5INI";
                    end;
                }
                field("Marca Adopcion - 5INI"; Rec."Marca Adopcion - 5INI")
                {
                    Editable = false;
                }
                field(t1PRI; t1PRI)
                {
                    Caption = '1PRI';
                    Editable = false;

                    trigger OnAssistEdit()
                    begin
                        if Rec."Marca Adopcion - 1PRI" = Rec."Adopcion - 1PRI" then
                            Rec."Marca Adopcion - 1PRI" := 0
                        else
                            Rec."Marca Adopcion - 1PRI" := Rec."Adopcion - 1PRI";
                    end;
                }
                field("Marca Adopcion - 1PRI"; Rec."Marca Adopcion - 1PRI")
                {
                    Editable = false;
                }
                field(t2PRI; t2PRI)
                {
                    Caption = '2PRI';
                    Editable = false;

                    trigger OnAssistEdit()
                    begin
                        if Rec."Marca Adopcion - 2PRI" = Rec."Adopcion - 2PRI" then
                            Rec."Marca Adopcion - 2PRI" := 0
                        else
                            Rec."Marca Adopcion - 2PRI" := Rec."Adopcion - 2PRI";
                    end;
                }
                field("Marca Adopcion - 2PRI"; Rec."Marca Adopcion - 2PRI")
                {
                    Editable = false;
                }
                field(t3PRI; t3PRI)
                {
                    Caption = '3PRI';
                    Editable = false;

                    trigger OnAssistEdit()
                    begin
                        if Rec."Marca Adopcion - 3PRI" = Rec."Adopcion - 3PRI" then
                            Rec."Marca Adopcion - 3PRI" := 0
                        else
                            Rec."Marca Adopcion - 3PRI" := Rec."Adopcion - 3PRI";
                    end;
                }
                field("Marca Adopcion - 3PRI"; Rec."Marca Adopcion - 3PRI")
                {
                    Editable = false;

                    trigger OnAssistEdit()
                    begin
                        if Rec."Marca Adopcion - 3PRI" = Rec."Adopcion - 3PRI" then
                            Rec."Marca Adopcion - 3PRI" := 0
                        else
                            Rec."Marca Adopcion - 3PRI" := Rec."Adopcion - 3PRI";
                    end;
                }
                field(t4PRI; t4PRI)
                {
                    Caption = '4PRI';
                    Editable = false;

                    trigger OnAssistEdit()
                    begin
                        if Rec."Marca Adopcion - 4PRI" = Rec."Adopcion - 4PRI" then
                            Rec."Marca Adopcion - 4PRI" := 0
                        else
                            Rec."Marca Adopcion - 4PRI" := Rec."Adopcion - 4PRI";
                    end;
                }
                field("Marca Adopcion - 4PRI"; Rec."Marca Adopcion - 4PRI")
                {
                    Editable = false;
                }
                field(t5PRI; t5PRI)
                {
                    Caption = '5PRI';
                    Editable = false;

                    trigger OnAssistEdit()
                    begin
                        if Rec."Marca Adopcion - 5PRI" = Rec."Adopcion - 5PRI" then
                            Rec."Marca Adopcion - 5PRI" := 0
                        else
                            Rec."Marca Adopcion - 5PRI" := Rec."Adopcion - 5PRI";
                    end;
                }
                field("Marca Adopcion - 5PRI"; Rec."Marca Adopcion - 5PRI")
                {
                    Editable = false;
                }
                field(t6PRI; t6PRI)
                {
                    Caption = '6PRI';
                    Editable = false;

                    trigger OnAssistEdit()
                    begin
                        if Rec."Marca Adopcion - 6PRI" = Rec."Adopcion - 6PRI" then
                            Rec."Marca Adopcion - 6PRI" := 0
                        else
                            Rec."Marca Adopcion - 6PRI" := Rec."Adopcion - 6PRI";
                    end;
                }
                field("Marca Adopcion - 6PRI"; Rec."Marca Adopcion - 6PRI")
                {
                    Editable = false;
                }
                field(t1SEC; t1SEC)
                {
                    Caption = '1SEC';
                    Editable = false;

                    trigger OnAssistEdit()
                    begin
                        if Rec."Marca Adopcion - 1SEC" = Rec."Adopcion - 1SEC" then
                            Rec."Marca Adopcion - 1SEC" := 0
                        else
                            Rec."Marca Adopcion - 1SEC" := Rec."Adopcion - 1SEC";
                    end;
                }
                field("Marca Adopcion - 1SEC"; Rec."Marca Adopcion - 1SEC")
                {
                    Editable = false;
                }
                field(t2SEC; t2SEC)
                {
                    Caption = '2SEC';
                    Editable = false;

                    trigger OnAssistEdit()
                    begin
                        if Rec."Marca Adopcion - 2SEC" = Rec."Adopcion - 2SEC" then
                            Rec."Marca Adopcion - 2SEC" := 0
                        else
                            Rec."Marca Adopcion - 2SEC" := Rec."Adopcion - 2SEC";
                    end;
                }
                field("Marca Adopcion - 2SEC"; Rec."Marca Adopcion - 2SEC")
                {
                    Editable = false;
                }
                field(t3SEC; t3SEC)
                {
                    Caption = '3SEC';
                    Editable = false;

                    trigger OnAssistEdit()
                    begin
                        if Rec."Marca Adopcion - 3SEC" = Rec."Adopcion - 3SEC" then
                            Rec."Marca Adopcion - 3SEC" := 0
                        else
                            Rec."Marca Adopcion - 3SEC" := Rec."Adopcion - 3SEC";
                    end;
                }
                field("Marca Adopcion - 3SEC"; Rec."Marca Adopcion - 3SEC")
                {
                    Editable = false;
                }
                field(t4SEC; t4SEC)
                {
                    Caption = '4SEC';
                    Editable = false;

                    trigger OnAssistEdit()
                    begin
                        if Rec."Marca Adopcion - 4SEC" = Rec."Adopcion - 4SEC" then
                            Rec."Marca Adopcion - 4SEC" := 0
                        else
                            Rec."Marca Adopcion - 4SEC" := Rec."Adopcion - 4SEC";
                    end;
                }
                field("Marca Adopcion - 4SEC"; Rec."Marca Adopcion - 4SEC")
                {
                    Editable = false;
                }
                field(t5SEC; t5SEC)
                {
                    Caption = '5SEC';
                    Editable = false;

                    trigger OnAssistEdit()
                    begin
                        if Rec."Marca Adopcion - 5SEC" = Rec."Adopcion - 5SEC" then
                            Rec."Marca Adopcion - 5SEC" := 0
                        else
                            Rec."Marca Adopcion - 5SEC" := Rec."Adopcion - 5SEC";
                    end;
                }
                field("Marca Adopcion - 5SEC"; Rec."Marca Adopcion - 5SEC")
                {
                    Editable = false;
                }
                field(t1SEI; t1SEI)
                {
                    Caption = '1SEI';
                    Editable = false;

                    trigger OnAssistEdit()
                    begin
                        if Rec."Marca Adopcion - 1SEI" = Rec."Adopcion - 1SEI" then
                            Rec."Marca Adopcion - 1SEI" := 0
                        else
                            Rec."Marca Adopcion - 1SEI" := Rec."Adopcion - 1SEI";
                    end;
                }
                field("Marca Adopcion - 1SEI"; Rec."Marca Adopcion - 1SEI")
                {
                    Editable = false;
                }
                field(t2SEI; t2SEI)
                {
                    Caption = '2SEI';
                    Editable = false;

                    trigger OnAssistEdit()
                    begin
                        if Rec."Marca Adopcion - 2SEI" = Rec."Adopcion - 2SEI" then
                            Rec."Marca Adopcion - 2SEI" := 0
                        else
                            Rec."Marca Adopcion - 2SEI" := Rec."Adopcion - 2SEI";
                    end;
                }
                field("Marca Adopcion - 2SEI"; Rec."Marca Adopcion - 2SEI")
                {
                    Editable = false;
                }
                field(t3SEI; t3SEI)
                {
                    Caption = '3SEI';
                    Editable = false;

                    trigger OnAssistEdit()
                    begin
                        if Rec."Marca Adopcion - 3SEI" = Rec."Adopcion - 3SEI" then
                            Rec."Marca Adopcion - 3SEI" := 0
                        else
                            Rec."Marca Adopcion - 3SEI" := Rec."Adopcion - 3SEI";
                    end;
                }
                field("Marca Adopcion - 3SEI"; Rec."Marca Adopcion - 3SEI")
                {
                    Editable = false;
                }
                field(t4SEI; t4SEI)
                {
                    Caption = '4SEI';
                    Editable = false;

                    trigger OnAssistEdit()
                    begin
                        if Rec."Marca Adopcion - 4SEI" = Rec."Adopcion - 4SEI" then
                            Rec."Marca Adopcion - 4SEI" := 0
                        else
                            Rec."Marca Adopcion - 4SEI" := Rec."Adopcion - 4SEI";
                    end;
                }
                field("Marca Adopcion - 4SEI"; Rec."Marca Adopcion - 4SEI")
                {
                    Editable = false;
                }
                field(t1VA; t1VA)
                {
                    Caption = '1VA';
                    Editable = false;

                    trigger OnAssistEdit()
                    begin
                        if Rec."Marca Adopcion - 1VA" = Rec."Adopcion - 1VA" then
                            Rec."Marca Adopcion - 1VA" := 0
                        else
                            Rec."Marca Adopcion - 1VA" := Rec."Adopcion - 1VA";
                    end;
                }
                field("Marca Adopcion - 1VA"; Rec."Marca Adopcion - 1VA")
                {
                    Editable = false;
                }
                field(t2VA; t2VA)
                {
                    Caption = '2VA';
                    Editable = false;

                    trigger OnAssistEdit()
                    begin
                        if Rec."Marca Adopcion - 2VA" = Rec."Adopcion - 2VA" then
                            Rec."Marca Adopcion - 2VA" := 0
                        else
                            Rec."Marca Adopcion - 2VA" := Rec."Adopcion - 2VA";
                    end;
                }
                field("Marca Adopcion - 2VA"; Rec."Marca Adopcion - 2VA")
                {
                    Editable = false;
                }
                field(t3VA; t3VA)
                {
                    Caption = '3VA';
                    Editable = false;

                    trigger OnAssistEdit()
                    begin
                        if Rec."Marca Adopcion - 3VA" = Rec."Adopcion - 3VA" then
                            Rec."Marca Adopcion - 3VA" := 0
                        else
                            Rec."Marca Adopcion - 3VA" := Rec."Adopcion - 3VA";
                    end;
                }
                field("Marca Adopcion - 3VA"; Rec."Marca Adopcion - 3VA")
                {
                    Editable = false;
                }
                field(t4VA; t4VA)
                {
                    Caption = '4VA';
                    Editable = false;

                    trigger OnAssistEdit()
                    begin
                        if Rec."Marca Adopcion - 4VA" = Rec."Adopcion - 4VA" then
                            Rec."Marca Adopcion - 4VA" := 0
                        else
                            Rec."Marca Adopcion - 4VA" := Rec."Adopcion - 4VA";
                    end;
                }
                field("Marca Adopcion - 4VA"; Rec."Marca Adopcion - 4VA")
                {
                    Editable = false;
                }
                field(t5VA; t5VA)
                {
                    Caption = '5VA';
                    Editable = false;

                    trigger OnAssistEdit()
                    begin
                        if Rec."Marca Adopcion - 5VA" = Rec."Adopcion - 5VA" then
                            Rec."Marca Adopcion - 5VA" := 0
                        else
                            Rec."Marca Adopcion - 5VA" := Rec."Adopcion - 5VA";
                    end;
                }
                field("Marca Adopcion - 5VA"; Rec."Marca Adopcion - 5VA")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        t2INI := Format(Rec."Adopcion - 2INI");
        t3INI := Format(Rec."Adopcion - 3INI");
        t4INI := Format(Rec."Adopcion - 4INI");
        t5INI := Format(Rec."Adopcion - 5INI");
        t1PRI := Format(Rec."Adopcion - 1PRI");
        t2PRI := Format(Rec."Adopcion - 2PRI");
        t3PRI := Format(Rec."Adopcion - 3PRI");
        t4PRI := Format(Rec."Adopcion - 4PRI");
        t5PRI := Format(Rec."Adopcion - 5PRI");
        t6PRI := Format(Rec."Adopcion - 6PRI");
        t1SEC := Format(Rec."Adopcion - 1SEC");
        t2SEC := Format(Rec."Adopcion - 2SEC");
        t3SEC := Format(Rec."Adopcion - 3SEC");
        t4SEC := Format(Rec."Adopcion - 4SEC");
        t5SEC := Format(Rec."Adopcion - 5SEC");
        t1SEI := Format(Rec."Adopcion - 1SEI");
        t2SEI := Format(Rec."Adopcion - 2SEI");
        t3SEI := Format(Rec."Adopcion - 3SEI");
        t4SEI := Format(Rec."Adopcion - 4SEI");
        t1VA := Format(Rec."Adopcion - 1VA");
        t2VA := Format(Rec."Adopcion - 2VA");
        t3VA := Format(Rec."Adopcion - 3VA");
        t4VA := Format(Rec."Adopcion - 4VA");
        t5VA := Format(Rec."Adopcion - 5VA");
    end;

    trigger OnOpenPage()
    begin
        Rec.SetRange("Cod. Colegio", gCodColegio);
        Rec.SetRange("Cod. Docente", gCodDocente);
    end;

    var
        ConfAPS: Record "Commercial Setup";
        Item: Record Item;
        DefDim: Record "Default Dimension";
        TextoEncabezado: array[30] of Text[30];
        DimValue: Text[60];
        i: Integer;
        gCodDocente: Code[20];
        gCodColegio: Code[20];
        t2INI: Text[30];
        t3INI: Text[30];
        t4INI: Text[30];
        t5INI: Text[30];
        t1PRI: Text[30];
        t2PRI: Text[30];
        t3PRI: Text[30];
        t4PRI: Text[30];
        t5PRI: Text[30];
        t6PRI: Text[30];
        t1SEC: Text[30];
        t2SEC: Text[30];
        t3SEC: Text[30];
        t4SEC: Text[30];
        t5SEC: Text[30];
        t1SEI: Text[30];
        t2SEI: Text[30];
        t3SEI: Text[30];
        t4SEI: Text[30];
        t1VA: Text[30];
        t2VA: Text[30];
        t3VA: Text[30];
        t4VA: Text[30];
        t5VA: Text[30];


    procedure RecibeParametros(CodDoc: Code[20]; CodCol: Code[20])
    var
        ColAdopDetalle: Record "Colegio - Adopciones Detalle";
        Grados: Record "Datos auxiliares";
    begin
        gCodColegio := CodCol;
        gCodDocente := CodDoc;
        ConfAPS.Get();
        ConfAPS.TestField("Dim para Estad. Adopciones");
        i := 0;

        DimValue := ' ';
        Grados.Reset;
        Grados.SetRange("Tipo registro", Grados."Tipo registro"::Grados);
        Grados.Find('-');
        repeat
            i += 1;
            TextoEncabezado[i] := Grados.Codigo;
        until Grados.Next = 0;


        ColAdopDetalle.Reset;
        ColAdopDetalle.SetCurrentKey("Cod. Colegio", "Linea de negocio", Familia, "Sub Familia", Serie, "Grupo de Negocio");
        ColAdopDetalle.SetRange("Cod. Colegio", CodCol);
        ColAdopDetalle.SetFilter(Adopcion, '<>%1', 0);
        //ColAdopDetalle.SETRANGE("Cod. Nivel",CodNivel);
        //ColAdopDetalle.SETRANGE("Cod. Turno",CodTurno);
        //ColAdopDetalle.SETRANGE("Cod. Grado",CodGrado);
        ColAdopDetalle.FindSet;
        repeat
            /*
              IF ConfAPS."Dim para Estad. Adopciones" = ConfAPS."Cod. Dimension Lin. Negocio" THEN
                 BEGIN
                  IF ColAdopDetalle."Linea de negocio" <> DimValue THEN
                     BEGIN
                      INIT;
                      DimValue := ColAdopDetalle."Linea de negocio";
                     END;
                 END
              ELSE
              IF ConfAPS."Dim para Estad. Adopciones" = ConfAPS."Cod. Dimension Familia" THEN
                 BEGIN
                  IF ColAdopDetalle.Familia <> DimValue THEN
                     BEGIN
                      INIT;
                      DimValue := ColAdopDetalle.Familia;
                     END;
                 END
              ELSE
              IF ConfAPS."Dim para Estad. Adopciones" = ConfAPS."Cod. Dimension Sub Familia" THEN
                 BEGIN
                  IF ColAdopDetalle."Sub Familia" <> DimValue THEN
                     BEGIN
                      INIT;
                      DimValue := ColAdopDetalle."Sub Familia";
                     END;
                 END
              ELSE
              IF ConfAPS."Dim para Estad. Adopciones" = ConfAPS."Cod. Dimension Serie" THEN
                 BEGIN
                  IF ColAdopDetalle.Serie <> DimValue THEN
                     BEGIN
                      INIT;
                      DimValue := ColAdopDetalle.Serie;
                     END;
                 END;
            */
            if not Rec.Get(CodDoc, CodCol, ColAdopDetalle."Cod. Local", ColAdopDetalle."Cod. Producto") then
                Rec.Init;

            Rec."Cod. Docente" := CodDoc;
            Rec."Cod. Colegio" := ColAdopDetalle."Cod. Colegio";
            Rec."Cod. Nivel" := ColAdopDetalle."Cod. Nivel";
            Rec."Cod. Grado" := ColAdopDetalle."Cod. Grado";
            Rec."Cod. Turno" := ColAdopDetalle."Cod. Turno";
            Rec."Linea de negocio" := ColAdopDetalle."Linea de negocio";
            Rec.Familia := ColAdopDetalle.Familia;
            Rec."Sub Familia" := DimValue;
            Rec.Serie := ColAdopDetalle.Serie;
            //"Cod. Editorial"   := ColAdopDetalle."Cod. Editorial";
            Rec."Cod. Local" := ColAdopDetalle."Cod. Local";
            Rec."Cod. Promotor" := ColAdopDetalle."Cod. Promotor";
            Rec."Cod. Producto" := ColAdopDetalle."Cod. Producto";
            Item.Get(Rec."Cod. Producto");

            DefDim.Reset;
            DefDim.SetRange("Table ID", 27);
            DefDim.SetRange("No.", Rec."Cod. Producto");
            DefDim.SetRange("Dimension Code", 'EDICION_COLECCION');
            if DefDim.FindFirst then
                Rec."Edicion Coleccion" := DefDim."Dimension Value Code";

            Rec."Descripción producto" := Item.Description;
            if Rec.FieldCaption("2INI") = ColAdopDetalle."Cod. Grado" then begin
                Rec."Adopcion - 2INI" := ColAdopDetalle.Adopcion;
            end
            else
                if Rec.FieldCaption("3INI") = ColAdopDetalle."Cod. Grado" then begin
                    Rec."Adopcion - 3INI" := ColAdopDetalle.Adopcion;
                end
                else
                    if Rec.FieldCaption("4INI") = ColAdopDetalle."Cod. Grado" then begin
                        Rec."Adopcion - 4INI" := ColAdopDetalle.Adopcion;
                    end
                    else
                        if Rec.FieldCaption("5INI") = ColAdopDetalle."Cod. Grado" then begin
                            Rec."Adopcion - 5INI" := ColAdopDetalle.Adopcion;
                        end
                        else
                            if Rec.FieldCaption("1PRI") = ColAdopDetalle."Cod. Grado" then begin
                                Rec."Adopcion - 1PRI" := ColAdopDetalle.Adopcion;
                            end
                            else
                                if Rec.FieldCaption("2PRI") = ColAdopDetalle."Cod. Grado" then begin
                                    Rec."Adopcion - 2PRI" := ColAdopDetalle.Adopcion;
                                end
                                else
                                    if Rec.FieldCaption("3PRI") = ColAdopDetalle."Cod. Grado" then begin
                                        Rec."Adopcion - 3PRI" := ColAdopDetalle.Adopcion;
                                    end
                                    else
                                        if Rec.FieldCaption("4PRI") = ColAdopDetalle."Cod. Grado" then begin
                                            Rec."Adopcion - 4PRI" := ColAdopDetalle.Adopcion;
                                        end
                                        else
                                            if Rec.FieldCaption("5PRI") = ColAdopDetalle."Cod. Grado" then begin
                                                Rec."Adopcion - 5PRI" := ColAdopDetalle.Adopcion;
                                            end
                                            else
                                                if Rec.FieldCaption("6PRI") = ColAdopDetalle."Cod. Grado" then begin
                                                    Rec."Adopcion - 6PRI" := ColAdopDetalle.Adopcion;
                                                end
                                                else
                                                    if Rec.FieldCaption("1SEC") = ColAdopDetalle."Cod. Grado" then begin
                                                        Rec."Adopcion - 1SEC" := ColAdopDetalle.Adopcion;
                                                    end
                                                    else
                                                        if Rec.FieldCaption("2SEC") = ColAdopDetalle."Cod. Grado" then begin
                                                            Rec."Adopcion - 2SEC" := ColAdopDetalle.Adopcion;
                                                        end
                                                        else
                                                            if Rec.FieldCaption("3SEC") = ColAdopDetalle."Cod. Grado" then begin
                                                                Rec."Adopcion - 3SEC" := ColAdopDetalle.Adopcion;
                                                            end
                                                            else
                                                                if Rec.FieldCaption("4SEC") = ColAdopDetalle."Cod. Grado" then begin
                                                                    Rec."Adopcion - 4SEC" := ColAdopDetalle.Adopcion;
                                                                end
                                                                else
                                                                    if Rec.FieldCaption("5SEC") = ColAdopDetalle."Cod. Grado" then begin
                                                                        Rec."Adopcion - 5SEC" := ColAdopDetalle.Adopcion;
                                                                    end
                                                                    else
                                                                        if Rec.FieldCaption("1SEI") = ColAdopDetalle."Cod. Grado" then begin
                                                                            Rec."Adopcion - 1SEI" := ColAdopDetalle.Adopcion;
                                                                        end
                                                                        else
                                                                            if Rec.FieldCaption("2SEI") = ColAdopDetalle."Cod. Grado" then begin
                                                                                Rec."Adopcion - 2SEI" := ColAdopDetalle.Adopcion;
                                                                            end
                                                                            else
                                                                                if Rec.FieldCaption("3SEI") = ColAdopDetalle."Cod. Grado" then begin
                                                                                    Rec."Adopcion - 3SEI" := ColAdopDetalle.Adopcion;
                                                                                end
                                                                                else
                                                                                    if Rec.FieldCaption("4SEI") = ColAdopDetalle."Cod. Grado" then begin
                                                                                        Rec."Adopcion - 4SEI" := ColAdopDetalle.Adopcion;
                                                                                    end
                                                                                    else
                                                                                        if Rec.FieldCaption("1VA") = ColAdopDetalle."Cod. Grado" then begin
                                                                                            Rec."Adopcion - 1VA" := ColAdopDetalle.Adopcion;
                                                                                        end
                                                                                        else
                                                                                            if Rec.FieldCaption("2VA") = ColAdopDetalle."Cod. Grado" then begin
                                                                                                Rec."Adopcion - 2VA" := ColAdopDetalle.Adopcion;
                                                                                            end
                                                                                            else
                                                                                                if Rec.FieldCaption("3VA") = ColAdopDetalle."Cod. Grado" then begin
                                                                                                    Rec."Adopcion - 3VA" := ColAdopDetalle.Adopcion;
                                                                                                end
                                                                                                else
                                                                                                    if Rec.FieldCaption("4VA") = ColAdopDetalle."Cod. Grado" then begin
                                                                                                        Rec."Adopcion - 4VA" := ColAdopDetalle.Adopcion;
                                                                                                    end
                                                                                                    else
                                                                                                        if Rec.FieldCaption("5VA") = ColAdopDetalle."Cod. Grado" then begin
                                                                                                            Rec."Adopcion - 5VA" := ColAdopDetalle.Adopcion;
                                                                                                        end;

            if not Rec.Insert then
                Rec.Modify;
        until ColAdopDetalle.Next = 0;

    end;
}

#pragma implicitwith restore

