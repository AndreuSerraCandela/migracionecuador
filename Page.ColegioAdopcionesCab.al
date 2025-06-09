#pragma implicitwith disable
page 76134 "Colegio - Adopciones Cab"
{
    ApplicationArea = all;
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Shortcuts';
    RefreshOnActivate = true;
    SourceTable = "Colegio - Adopciones Cab";

    layout
    {
        area(content)
        {
            group(Adoption)
            {
                Caption = 'Adoption';
                field("Cod. Editorial"; rec."Cod. Editorial")
                {
                    Caption = 'Editor code, name';
                    Visible = false;
                }
                field("Nombre editorial"; rec."Nombre editorial")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                    Caption = 'School code, name';
                    Editable = false;
                }
                field("Nombre Colegio"; rec."Nombre Colegio")
                {
                    Editable = false;
                }
                field("FuncAPS.ColCalcInvMuestras(""Cod. Colegio"")"; FuncAPS.ColCalcInvMuestras(Rec."Cod. Colegio"))
                {
                    Caption = 'Sample Inventory';
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Colegio: Record Contact;
                        BC: Record "Bin Content";
                        BCPage: Page "Bin Content";
                    begin
                        Colegio.Get(Rec."Cod. Colegio");
                        BC.Reset;
                        BC.SetRange("Location Code", Colegio."Samples Location Code");
                        BC.SetRange("Bin Code", Colegio."No.");
                        if BC.FindSet then begin
                            BCPage.SetTableView(BC);
                            BCPage.RunModal;
                            Clear(BCPage);
                        end;
                    end;
                }
                field("Cod. Promotor"; rec."Cod. Promotor")
                {
                    Editable = false;
                }
                field("Nombre Promotor"; rec."Nombre Promotor")
                {
                    Editable = false;
                }
                field("Filtro Grupo de Negocio"; rec."Filtro Grupo de Negocio")
                {

                    trigger OnValidate()
                    begin
                        CurrPage.TmpAdopciones.PAGE.RecibeFiltro(Rec."Filtro fecha", Rec."Filtro Linea de negocio", Rec."Filtro Grupo de Negocio", Rec."Filtro Nivel",
                                                                 Rec."Filtro Serie", Rec."Filtro Sub Familia");
                    end;
                }
                field("Filtro Linea de negocio"; rec."Filtro Linea de negocio")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        ConfAPS.Get();
                        ConfAPS.TestField("Cod. Dimension Lin. Negocio");

                        DimVal.Reset;
                        DimVal.SetRange("Dimension Code", ConfAPS."Cod. Dimension Lin. Negocio");
                        DimVal.SetRange("Dimension Value Type", DimVal."Dimension Value Type"::Standard);
                        DimForm.SetTableView(DimVal);
                        DimForm.SetRecord(DimVal);
                        DimForm.LookupMode(true);
                        if DimForm.RunModal = ACTION::LookupOK then begin
                            DimForm.GetRecord(DimVal);
                            Rec.Validate("Filtro Linea de negocio", DimVal.Code);
                            //    MESSAGE('%1 %2',"Filtro Linea de negocio",DimVal.Code);
                            //    CurrPage.TmpAdopciones.FORM.RecibeFiltro("Filtro fecha","Filtro Linea de negocio","Filtro Grupo de Negocio","Filtro Nivel");
                        end;

                        Clear(DimForm);
                    end;

                    trigger OnValidate()
                    begin
                        //MESSAGE('aa %1 %2',"Filtro Linea de negocio",DimVal.Code);
                        CurrPage.TmpAdopciones.PAGE.RecibeFiltro(Rec."Filtro fecha", Rec."Filtro Linea de negocio", Rec."Filtro Grupo de Negocio", Rec."Filtro Nivel",
                                                                 Rec."Filtro Serie", Rec."Filtro Sub Familia");
                    end;
                }
                field("Filtro Nivel"; Filtro)
                {
                    Caption = 'Level Filter';
                    TableRelation = "Nivel Educativo APS";

                    trigger OnValidate()
                    begin
                        Rec."Filtro Nivel" := Filtro;
                        CurrPage.TmpAdopciones.PAGE.RecibeFiltro(Rec."Filtro fecha", Rec."Filtro Linea de negocio", Rec."Filtro Grupo de Negocio", Rec."Filtro Nivel",
                                                                 Rec."Filtro Serie", Rec."Filtro Sub Familia");
                    end;
                }
                field("Filtro Sub Familia"; rec."Filtro Sub Familia")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        ConfAPS.Get();
                        ConfAPS.TestField("Cod. Dimension Sub Familia");
                        DimVal.Reset;
                        DimVal.SetRange("Dimension Code", ConfAPS."Cod. Dimension Sub Familia");
                        DimVal.SetRange("Dimension Value Type", DimVal."Dimension Value Type"::Standard);
                        DimForm.SetTableView(DimVal);
                        DimForm.SetRecord(DimVal);
                        DimForm.LookupMode(true);
                        if DimForm.RunModal = ACTION::LookupOK then begin
                            DimForm.GetRecord(DimVal);
                            Rec.Validate("Filtro Sub Familia", DimVal.Code);
                            CurrPage.TmpAdopciones.PAGE.RecibeFiltro(Rec."Filtro fecha", Rec."Filtro Linea de negocio", Rec."Filtro Grupo de Negocio", Rec."Filtro Nivel",
                                                                     Rec."Filtro Serie", Rec."Filtro Sub Familia");
                        end;

                        Clear(DimForm);
                    end;

                    trigger OnValidate()
                    begin
                        CurrPage.TmpAdopciones.PAGE.RecibeFiltro(Rec."Filtro fecha", Rec."Filtro Linea de negocio", Rec."Filtro Grupo de Negocio", Rec."Filtro Nivel",
                                                                 Rec."Filtro Serie", Rec."Filtro Sub Familia");
                    end;
                }
                field("Filtro Serie"; rec."Filtro Serie")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        ConfAPS.Get();
                        ConfAPS.TestField("Cod. Dimension Serie");
                        DimVal.Reset;
                        DimVal.SetRange("Dimension Code", ConfAPS."Cod. Dimension Serie");
                        DimVal.SetRange("Dimension Value Type", DimVal."Dimension Value Type"::Standard);
                        DimForm.SetTableView(DimVal);
                        DimForm.SetRecord(DimVal);
                        DimForm.LookupMode(true);
                        if DimForm.RunModal = ACTION::LookupOK then begin
                            DimForm.GetRecord(DimVal);
                            Rec.Validate("Filtro Serie", DimVal.Code);
                            CurrPage.TmpAdopciones.PAGE.RecibeFiltro(Rec."Filtro fecha", Rec."Filtro Linea de negocio", Rec."Filtro Grupo de Negocio", Rec."Filtro Nivel",
                                                                     Rec."Filtro Serie", Rec."Filtro Sub Familia");
                        end;

                        Clear(DimForm);
                    end;

                    trigger OnValidate()
                    begin
                        CurrPage.TmpAdopciones.PAGE.RecibeFiltro(Rec."Filtro fecha", Rec."Filtro Linea de negocio", Rec."Filtro Grupo de Negocio", Rec."Filtro Nivel",
                                                                 Rec."Filtro Serie", Rec."Filtro Sub Familia");
                    end;
                }
                field("Filtro fecha"; rec."Filtro fecha")
                {
                }
                field("% Dto. Padres"; rec."% Dto. Padres")
                {
                    Importance = Additional;

                    trigger OnValidate()
                    begin
                        CurrPage.TmpAdopciones.PAGE.UpdForm;
                    end;
                }
                field("% Dto. Colegio"; rec."% Dto. Colegio")
                {
                    Importance = Additional;

                    trigger OnValidate()
                    begin
                        CurrPage.TmpAdopciones.PAGE.UpdForm;
                    end;
                }
                field("% Dto. Docente"; rec."% Dto. Docente")
                {
                    Importance = Additional;

                    trigger OnValidate()
                    begin
                        CurrPage.TmpAdopciones.PAGE.UpdForm;
                    end;
                }
                field("% Dto. Feria Padres"; rec."% Dto. Feria Padres")
                {
                    Importance = Additional;

                    trigger OnValidate()
                    begin
                        CurrPage.TmpAdopciones.PAGE.UpdForm;
                    end;
                }
                field("% Dto. Feria Colegio"; rec."% Dto. Feria Colegio")
                {
                    Importance = Additional;

                    trigger OnValidate()
                    begin
                        CurrPage.TmpAdopciones.PAGE.UpdForm;
                    end;
                }
                field(Campana; rec.Campana)
                {
                    Importance = Additional;
                }
            }
            part(TmpAdopciones; "Colegio - Adopciones Detalles")
            {
                SubPageLink = "Cod. Colegio" = FIELD("Cod. Colegio"),
                              "Cod. Nivel" = FIELD(FILTER("Filtro Nivel")),
                              "Cod. Turno" = FIELD(Turno),
                              "Cod. Promotor" = FIELD("Cod. Promotor"),
                              "Linea de negocio" = FIELD(FILTER("Filtro Linea de negocio")),
                              Serie = FIELD(FILTER("Filtro Serie")),
                              "Sub Familia" = FIELD(FILTER("Filtro Sub Familia"));
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action1000000016>")
            {
                Caption = '&School';
                action(FProm)
                {
                    Caption = 'Salesperson Card';
                    Image = TeamSales;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "Salesperson/Purchaser Card";
                    RunPageLink = Code = FIELD("Cod. Promotor");
                    ShortCutKey = 'Shift+F5';
                }
                action(FCol)
                {
                    Caption = '&School Card';
                    Image = Edit;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "Contact Card";
                    RunPageLink = "No." = FIELD("Cod. Colegio");
                }
                separator(Action1000000007)
                {
                }
                action(Estad)
                {
                    Caption = '&Statistic';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    var
                        Estad: Page "Estadistica Adopciones";
                    begin
                        Estad.RecibeParametros(Rec."Cod. Colegio");
                        Estad.Run;
                        Clear(Estad);
                    end;
                }
                action(Refresh)
                {
                    Caption = 'Refresh';
                    Image = Refresh;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        FiltroNivel: Text[100];
                    begin
                        FuncAPS.InsertaAdopciones(Rec."Cod. Colegio", Filtro, Rec."Cod. Promotor", Rec.Turno);
                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        /*IF HAdopciones.FINDLAST THEN
           Ano := HAdopciones.Campana
        ELSE
           BEGIN
            Ano := DATE2DMY(TODAY,3);
            Ano -= 1;
           END;
        */

    end;

    trigger OnOpenPage()
    begin
        Rec.Validate("Cod. Promotor", gCodPromotor);
        Rec.Validate("Cod. Colegio", gCodCol);
        //VALIDATE("Cod. Local",gCodLocal);
        Rec.Validate("Cod. Nivel", gCodNivel);
        Rec.Validate(Turno, gCodTurno);
        Rec.Validate("Cod. Promotor", gCodPromotor);
        if Rec.Insert(true) then;
    end;

    var
        Adopciones: Record "Colegio - Log - Adopciones";
        Adopciones2: Record "Colegio - Log - Adopciones";
        AdopcionesD: Record "Colegio - Adopciones Detalle";
        HAdopciones: Record "Historico Adopciones";
        Item: Record Item;
        PptoPromotor: Record "Promotor - Ppto Vtas";
        TempAdopciones: Record "Colegio - Log - Adopciones" temporary;
        GradosCol: Record "Colegio - Grados";
        Editoriales: Record Editoras;
        ConfAPS: Record "Commercial Setup";
        Nivel: Record "Nivel Educativo APS";
        DefDim: Record "Default Dimension";
        DimVal: Record "Dimension Value";
        FuncAPS: Codeunit "Funciones APS";
        Table_ID: Integer;
        MigratedTables: Integer;
        TotalNoOfTables: Integer;
        Window: Dialog;
        MatrixColumnCaptions: array[100] of Text[100];
        NoMov: Integer;
        gCodCol: Code[20];
        gCodNivel: Code[20];
        gCodPromotor: Code[20];
        gCodRuta: Code[20];
        gCodTurno: Code[20];
        gCodLocal: Code[20];
        Msg001: Label 'There''s a change in the discount, do you wish to update the lines?';
        CounterTotal: Integer;
        Counter: Integer;
        Text001: Label 'Filling  #1########## @2@@@@@@@@@@@@@';
        Turnos: Page Turnos;
        DimForm: Page "Dimension Value List";
        Filtro: Text[100];


    procedure RecibeParametros(CodCol: Code[20]; CodNivel: Code[20]; CodPromotor: Code[20]; CodRuta: Code[20]; CodTurno: Code[20])
    begin
        gCodCol := CodCol;
        gCodNivel := CodNivel;
        gCodPromotor := CodPromotor;
        gCodRuta := CodRuta;
        gCodTurno := CodTurno;
    end;
}

#pragma implicitwith restore

