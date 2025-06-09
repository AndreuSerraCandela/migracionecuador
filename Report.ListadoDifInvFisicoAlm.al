report 56032 "Listado Dif. Inv. Fisico Alm."
{
    DefaultLayout = RDLC;
    RDLCLayout = './ListadoDifInvFisicoAlm.rdlc';

    dataset
    {
        dataitem("Warehouse Journal Line"; "Warehouse Journal Line")
        {
            DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Location Code", "Line No.");
            column(COMPANYNAME; CompanyName)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(USERID; UserId)
            {
            }
            /*column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }*/
            column(GetShorDimCodeCaption2; GetShorDimCodeCaption2)
            {
            }
            column(GetShorDimCodeCaption1; GetShorDimCodeCaption1)
            {
            }
            column(ShowLotSN; ShowLotSN)
            {
            }
            column(Filtros; Filtros)
            {
            }
            column(CodSeccion1; StrSubstNo(Text001, CodSeccion1))
            {
            }
            column(CodSeccion2; StrSubstNo(Text001, CodSeccion2))
            {
            }
            column(Warehouse_Journal_Line__Posting_Date_; Format("Registering Date"))
            {
            }
            column(Warehouse_Journal_Line__Item_No__; "Item No.")
            {
            }
            column(Warehouse_Journal_Line_Description; Description)
            {
            }
            column(Warehouse_Journall_Line__Location_Code_; "Location Code")
            {
            }
            column(CalcQty1; CalcQty1)
            {
            }
            column(Warehouse_Journal_Line__Bin_Code_; "Bin Code")
            {
            }
            column(CalcQty2; CalcQty2)
            {
            }
            column(DifQty; DifQty)
            {
            }
            column(Phys__Inventory_ListCaption; Phys__Inventory_ListCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Item_Journal_Line__Posting_Date_Caption; Item_Journal_Line__Posting_Date_CaptionLbl)
            {
            }
            column(Item_Journal_Line__Item_No__Caption; FieldCaption("Item No."))
            {
            }
            column(Item_Journal_Line_DescriptionCaption; FieldCaption(Description))
            {
            }
            column(Item_Journal_Line__Location_Code_Caption; FieldCaption("Location Code"))
            {
            }
            column(Item_Journal_Line__Bin_Code_Caption; FieldCaption("Bin Code"))
            {
            }
            column(Diff_Caption; Diff_CaptionLbl)
            {
            }
            column(Warehouse_Journal_Line_Journal_Template_Name; "Journal Template Name")
            {
            }
            column(Warehouse_Journal_Line_Journal_Batch_Name; "Journal Batch Name")
            {
            }
            column(Warehouse_Journal_Line_Line_No_; "Line No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                CalcQty1 := "Qty. (Phys. Inventory)";

                IJL.Reset;
                IJL.SetRange("Journal Template Name", CodDiario);
                IJL.SetRange("Journal Batch Name", CodSeccion2);
                IJL.SetRange("Item No.", "Item No.");
                IJL.SetRange("Location Code", "Location Code");
                IJL.SetRange("Bin Code", "Bin Code");
                if IJL.FindFirst then
                    CalcQty2 := IJL."Qty. (Phys. Inventory)";

                DifQty := CalcQty1 - CalcQty2;

                if (Traspasar) and (DifQty <> 0) then begin
                    IJL2.TransferFields("Warehouse Journal Line");
                    IJL2."Journal Template Name" := "Journal Template Name";
                    IJL2."Journal Batch Name" := CodSeccion3;
                    IJL2.Validate("Qty. (Phys. Inventory)", "Qty. (Calculated)");
                    IJL2.Insert(true);
                end
                else
                    if (Consolidar) and (DifQty = 0) then begin
                        IJL3.Reset;
                        IJL3.SetRange("Journal Template Name", CodDiario);
                        IJL3.SetRange("Journal Batch Name", CodSeccion4);
                        if IJL3.FindLast then
                            NoLin := IJL3."Line No."
                        else
                            NoLin := 0;

                        NoLin += 1000;

                        IJL2.TransferFields("Warehouse Journal Line");
                        IJL2."Journal Template Name" := "Journal Template Name";
                        IJL2."Journal Batch Name" := CodSeccion4;
                        IJL2."Line No." := NoLin;
                        IJL2.Validate("Qty. (Phys. Inventory)", "Qty. (Phys. Inventory)");
                        IJL2.Insert(true);
                    end
                    else
                        if (Consolidar) and (DifQty <> 0) then begin
                            IJL3.Reset;
                            IJL3.SetRange("Journal Template Name", CodDiario);
                            IJL3.SetRange("Journal Batch Name", CodSeccion4);
                            if IJL3.FindLast then
                                NoLin := IJL3."Line No."
                            else
                                NoLin := 0;

                            NoLin += 1000;

                            IJL4.Reset;
                            IJL4.SetRange("Journal Template Name", CodDiario);
                            IJL4.SetRange("Journal Batch Name", CodSeccion3);
                            IJL4.SetRange("Item No.", "Item No.");
                            IJL4.FindFirst;

                            IJL2.TransferFields("Warehouse Journal Line");
                            IJL2."Journal Template Name" := "Journal Template Name";
                            IJL2."Journal Batch Name" := CodSeccion4;
                            IJL2."Line No." := NoLin;
                            IJL2.Validate("Qty. (Phys. Inventory)", IJL4."Qty. (Phys. Inventory)");
                            IJL2.Insert(true);
                        end;
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Journal Template Name", CodDiario);
                SetRange("Journal Batch Name", CodSeccion1);

                Filtros := GetFilters + ', ' + StrSubstNo(Text002, CodSeccion2)
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(CodDiario; CodDiario)
                    {
                    ApplicationArea = All;
                        Caption = 'Phys. Inventory Journal';
                        TableRelation = "Warehouse Journal Batch";
                    }
                    field(CodSeccion1; CodSeccion1)
                    {
                    ApplicationArea = All;
                        Caption = 'Batch name 1';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            IJL.SetRange("Journal Template Name", CodDiario);
                            IJL.SetRange("Journal Batch Name", 'GENERAL');
                            "Warehouse Journal Line".LookupName(CodSeccion1, CodAlm, IJL);
                        end;

                        trigger OnValidate()
                        begin
                            IJL.SetRange("Journal Template Name", CodDiario);
                            IJL.SetRange("Journal Batch Name", 'GENERAL');
                            "Warehouse Journal Line".CheckName(CodSeccion1, CodAlm, IJL);
                        end;
                    }
                    field(CodSeccion2; CodSeccion2)
                    {
                    ApplicationArea = All;
                        Caption = 'Batch name 2';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            IJL.SetRange("Journal Template Name", CodDiario);
                            IJL.SetRange("Journal Batch Name", 'GENERICO');
                            "Warehouse Journal Line".LookupName(CodSeccion2, CodAlm, IJL);
                        end;

                        trigger OnValidate()
                        begin
                            IJL.SetRange("Journal Template Name", CodDiario);
                            IJL.SetRange("Journal Batch Name", 'GENERICO');
                            "Warehouse Journal Line".CheckName(CodSeccion2, CodAlm, IJL);
                        end;
                    }
                    field(Traspasar; Traspasar)
                    {
                    ApplicationArea = All;
                        Caption = 'Transfer differences';

                        trigger OnValidate()
                        begin
                            if Traspasar then
                                Consolidar := false;
                        end;
                    }
                    field(Consolidar; Consolidar)
                    {
                    ApplicationArea = All;
                        Caption = 'Consolidate';

                        trigger OnValidate()
                        begin
                            if Consolidar then
                                Traspasar := false;
                        end;
                    }
                    field(CodSeccion3; CodSeccion3)
                    {
                    ApplicationArea = All;
                        Caption = 'Difference Batch name';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            IJL.SetRange("Journal Template Name", CodDiario);
                            IJL.SetRange("Journal Batch Name", 'GENERICO');
                            "Warehouse Journal Line".LookupName(CodSeccion3, CodAlm, IJL);
                        end;

                        trigger OnValidate()
                        begin
                            IJL.SetRange("Journal Template Name", CodDiario);
                            IJL.SetRange("Journal Batch Name", 'GENERICO');
                            "Warehouse Journal Line".CheckName(CodSeccion3, CodAlm, IJL);
                        end;
                    }
                    field(CodSeccion4; CodSeccion4)
                    {
                    ApplicationArea = All;
                        Caption = 'Consolidate Batch name';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            IJL.SetRange("Journal Template Name", CodDiario);
                            IJL.SetRange("Journal Batch Name", 'GENERICO');
                            "Warehouse Journal Line".LookupName(CodSeccion4, CodAlm, IJL);
                        end;

                        trigger OnValidate()
                        begin
                            IJL.SetRange("Journal Template Name", CodDiario);
                            IJL.SetRange("Journal Batch Name", 'GENERICO');
                            "Warehouse Journal Line".CheckName(CodSeccion4, CodAlm, IJL);
                        end;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        IJL: Record "Warehouse Journal Line";
        IJL2: Record "Warehouse Journal Line";
        IJL3: Record "Warehouse Journal Line";
        IJL4: Record "Warehouse Journal Line";
        ItemJnlMgt: Codeunit ItemJnlManagement;
        CodDiario: Code[20];
        CodSeccion1: Code[20];
        CodSeccion2: Code[20];
        CodSeccion3: Code[20];
        CodSeccion4: Code[10];
        GetShorDimCodeCaption1: Text[30];
        GetShorDimCodeCaption2: Text[30];
        GetLotNoCaption: Text[80];
        GetSerialNoCaption: Text[80];
        GetQuantityBaseCaption: Text[80];
        GetSummaryPerItemCaption: Text[30];
        ShowLotSN: Boolean;
        Filtros: Text[250];
        CalcQty1: Decimal;
        CalcQty2: Decimal;
        DifQty: Decimal;
        Traspasar: Boolean;
        Text001: Label 'Phys. Qty. %1';
        Text002: Label '2nd Jnl Batch %1';
        Consolidar: Boolean;
        NoLin: Integer;
        CodBatch: Code[20];
        CodSecc: Code[20];
        CodAlm: Code[20];
        Phys__Inventory_ListCaptionLbl: Label 'Phys. Whse. Inventory Jnl. Comparative';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Item_Journal_Line__Posting_Date_CaptionLbl: Label 'Posting Date';
        Diff_CaptionLbl: Label 'Difference';


    procedure RecibeParametros(Batch: Code[20]; Secc: Code[20]; Almacen: Code[20])
    begin
        CodBatch := Batch;
        CodSecc := Secc;
        CodAlm := Almacen;
    end;
}

