xmlport 76313 "Importa Discounts Groups"
{

    schema
    {
        textelement(Discounts_Group)
        {
            textelement(ItemDiscGroup)
            {
                textelement(ItemDiscGroup_Code)
                {
                }
                textelement(ItemDiscGroup_Desc)
                {
                }

                trigger OnAfterAssignVariable()
                begin
                    Window.Update(1, rItemDiscGrp.Code);
                    rItemDiscGrp.Init;
                    rItemDiscGrp.Validate(Code, rItemDiscGrp.Code);
                    rItemDiscGrp.Validate(Description, rItemDiscGrp.Description);
                    if not rItemDiscGrp.Insert then
                        rItemDiscGrp.Modify;
                end;
            }
            textelement(CustDiscGrp)
            {
                textelement(CustDiscGrp_Code)
                {
                }
                textelement(CustDiscGrp_Desc)
                {
                }

                trigger OnAfterAssignVariable()
                begin
                    Window.Update(1, CustDiscGrp_Code);
                    rCustDiscGrp.Init;
                    rCustDiscGrp.Validate(Code, CustDiscGrp_Code);
                    rCustDiscGrp.Validate(Description, CustDiscGrp_Desc);
                    if not rCustDiscGrp.Insert then
                        rCustDiscGrp.Modify;
                end;
            }
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

    trigger OnPostXmlPort()
    begin
        Window.Close;
    end;

    trigger OnPreXmlPort()
    begin
        Window.Open(txt001);
    end;

    var
        rItemDiscGrp: Record "Item Discount Group";
        rCustDiscGrp: Record "Customer Discount Group";
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        txt001: Label ' #1#########';
}

