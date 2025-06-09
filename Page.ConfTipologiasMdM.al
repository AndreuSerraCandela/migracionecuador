#pragma implicitwith disable
page 75006 "Conf. Tipologias MdM"
{
    ApplicationArea = all;
    //ApplicationArea = Basic, Suite, Service;
    Caption = 'Conf. Tipologias MdM';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Conf. Tipologias MdM";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = wEditable;
                field(Tipologia; rec.Tipologia)
                {
                    Style = StandardAccent;
                    StyleExpr = TRUE;

                    trigger OnValidate()
                    var
                        lrItemCat: Record "Item Category";
                    begin

                        if lrItemCat.Get(Rec.Tipologia) then begin
                            Rec."Gen. Prod. Posting Group" := lrItemCat."Def. Gen. Prod. Posting Group";
                            Rec."Inventory Posting Group" := lrItemCat."Def. Inventory Posting Group";
                            Rec."VAT Prod. Posting Group" := lrItemCat."Def. VAT Prod. Posting Group";
                            Rec."Costing Method" := lrItemCat."Def. Costing Method";
                            Rec."Item Disc. Group" := ''; // No existe
                            Rec."No. Series" := ''; // No existe
                        end;
                    end;
                }
                field("Referencia 1"; rec."Referencia 1")
                {
                    Editable = wRefEnbl1;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    Visible = wRefEnbl1;
                }
                field("Referencia 2"; rec."Referencia 2")
                {
                    Editable = wRefEnbl2;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    Visible = wRefEnbl2;
                }
                field("Referencia 3"; rec."Referencia 3")
                {
                    Editable = wRefEnbl3;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    Visible = wRefEnbl3;
                }
                field("Referencia 4"; rec."Referencia 4")
                {
                    Editable = wRefEnbl4;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    Visible = wRefEnbl4;
                }
                field("Referencia 5"; rec."Referencia 5")
                {
                    Editable = wRefEnbl5;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    Visible = wRefEnbl5;
                }
                field("Referencia 6"; rec."Referencia 6")
                {
                    Editable = wRefEnbl6;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    Visible = wRefEnbl6;
                }
                field("Referencia 7"; rec."Referencia 7")
                {
                    Editable = wRefEnbl7;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                    Visible = wRefEnbl7;
                }
                field("Gen. Prod. Posting Group"; rec."Gen. Prod. Posting Group")
                {
                }
                field("Inventory Posting Group"; rec."Inventory Posting Group")
                {
                }
                field("VAT Prod. Posting Group"; rec."VAT Prod. Posting Group")
                {
                }
                field("Costing Method"; rec."Costing Method")
                {
                }
                field("Item Disc. Group"; rec."Item Disc. Group")
                {
                }
                field("No. Series"; rec."No. Series")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Configuración Campos")
            {
                Image = SetupList;
                RunObject = Page "Conf.Filtros Tipologias MdM";
            }
        }
    }

    trigger OnOpenPage()
    var
        lrConfF: Record "Conf.Filtros Tipologias MdM";
        lwNo: Integer;
    begin
        wEditable := cFunMdm.GetEditable;
        CurrPage.Editable := wEditable;

        // Hacemos visibles solo las columnas configuradas
        wRefEnbl1 := lrConfF.Get(1);
        wRefEnbl2 := lrConfF.Get(2);
        wRefEnbl3 := lrConfF.Get(3);
        wRefEnbl4 := lrConfF.Get(4);
        wRefEnbl5 := lrConfF.Get(5);
        wRefEnbl6 := lrConfF.Get(6);
        wRefEnbl7 := lrConfF.Get(7);
    end;

    var
        wEditable: Boolean;
        cFunMdm: Codeunit "Funciones MdM";
        wRefEnbl1: Boolean;
        wRefEnbl2: Boolean;
        wRefEnbl3: Boolean;
        wRefEnbl4: Boolean;
        wRefEnbl5: Boolean;
        wRefEnbl6: Boolean;
        wRefEnbl7: Boolean;
}

#pragma implicitwith restore

