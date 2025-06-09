#pragma implicitwith disable
page 76121 "Cab. Planificacion"
{
    ApplicationArea = all;
    DataCaptionFields = "Cod. Promotor", "Nombre promotor";
    PageType = Card;
    SourceTable = "Cab. Planificacion";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(CodPromotor; rec."Cod. Promotor")
                {
                    Editable = PromEditable;
                }
                field("Nombre promotor"; rec."Nombre promotor")
                {
                    Editable = false;
                }
                field(Fecha; rec.Fecha)
                {
                    Editable = false;
                }
                field(Semana; rec.Semana)
                {
                }
                field("Fecha Inicial"; rec."Fecha Inicial")
                {
                    Editable = false;
                }
                field("Fecha Final"; rec."Fecha Final")
                {
                    Editable = false;
                }
            }
            part(Control1000000019; "Promotor - Planif. Visitas")
            {
                SubPageLink = "Cod. Promotor" = FIELD("Cod. Promotor"),
                              Semana = FIELD(Semana),
                              Ano = FIELD(Ano);
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Planning")
            {
                Caption = '&Planning';
                action("Seleccionar Colegios")
                {
                    Caption = 'Seleccionar Colegios';
                    Image = AddToHome;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        SelCol: Page "Promotores - Lista de Colegios";
                    begin

                        SelCol.RecibeParametros(Rec."Cod. Promotor", Rec.Ano, Rec.Semana);
                        //SelCol.LOOKUPMODE(TRUE);
                        SelCol.RunModal;
                        Clear(SelCol);
                    end;
                }
                action("&Post")
                {
                    Caption = '&Post';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        Planif.Reset;
                        Planif.SetRange("Cod. Promotor", Rec."Cod. Promotor");
                        Planif.SetRange(Semana, Rec.Semana);
                        Planif.SetRange(Estado, 0);
                        if Planif.FindSet(false) then
                            repeat
                                Planif.TestField("Fecha Visita");
                                Planif2.SetRange("Cod. Promotor", Rec."Cod. Promotor");
                                Planif2.SetRange("Cod. Colegio", Planif."Cod. Colegio");
                                Planif2.SetRange(Semana, Rec.Semana);
                                Planif2.SetRange(Estado, 0);
                                Planif2.FindSet;
                                repeat
                                    Planif2.Estado := 1;
                                    Planif2.Modify;
                                until Planif2.Next = 0;
                            until Planif.Next = 0;

                        /*
                        CabPlanifReg.INIT;
                        CabPlanifReg.TRANSFERFIELDS(Rec);
                        
                        CabPlanifReg.Estado := 1;
                        IF CabPlanifReg.INSERT THEN;
                        */
                        Rec.Estado := 1;
                        Rec.Modify;
                        //DELETE;
                        Message(Text001);
                        CurrPage.Close;

                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        User.Get(UserId);
        //User.TESTFIELD("Salespers./Purch. Code");
        if Promotor.Get(User."Salespers./Purch. Code") then;

        if (User."Salespers./Purch. Code" <> '') and (Promotor.Tipo = Promotor.Tipo::Vendedor) then begin
            Rec.SetRange("Cod. Promotor", User."Salespers./Purch. Code");
            PromEditable := false;
            //    VALIDATE("Cod. Promotor",User."Salespers./Purch. Code");
        end
        else
            PromEditable := true;
    end;

    var
        CabPlanifReg: Record "Cab. Planificacion";
        User: Record "User Setup";
        Promotor: Record "Salesperson/Purchaser";
        Planif: Record "Promotor - Planif. Visita";
        Planif2: Record "Promotor - Planif. Visita";
        Text001: Label 'The planning has been posted';
        PromEditable: Boolean;
}

#pragma implicitwith restore

