#pragma implicitwith disable
page 76122 "Cab. Planificacion Reg."
{
    ApplicationArea = all;
    DataCaptionFields = "Cod. Promotor", "Nombre promotor";
    Editable = false;
    PageType = Card;
    SourceTable = "Cab. Planificacion";
    SourceTableView = SORTING("Cod. Promotor", Semana)
                      WHERE(Estado = FILTER(> " "));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Cod. Promotor"; rec."Cod. Promotor")
                {
                    Editable = false;
                }
                field("Nombre promotor"; rec."Nombre promotor")
                {
                    Editable = false;
                }
                field(Fecha; rec.Fecha)
                {
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
            part(sfVisitas; "Promotor - Planif. Visitas")
            {
                Editable = false;
                SubPageLink = "Cod. Promotor" = FIELD("Cod. Promotor"),
                              Semana = FIELD(Semana),
                              Estado = FILTER(> " ");
                SubPageView = SORTING("Cod. Promotor", "Cod. Colegio", Semana);
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
                        if Planif.FindSet(false) then
                            repeat
                                Planif.TestField(Estado, 2);
                                Planif2.Get(Rec."Cod. Promotor", Planif."Cod. Colegio", Rec.Semana, Planif."Fecha Visita");
                                Planif2.Estado := 2;
                                Planif2.Semana := Rec.Semana;
                                Planif2.Modify;
                            until Planif.Next = 0;

                        CabPlanifReg.Get(Rec."Cod. Promotor", Rec.Semana);
                        CabPlanifReg.Estado := 2;
                        CabPlanifReg.Modify;

                        //DELETE;
                        Message(Text001);
                        CurrPage.Close;
                    end;
                }
            }
        }
    }

    var
        CabPlanifReg: Record "Cab. Planificacion";
        User: Record "User Setup";
        Planif: Record "Promotor - Planif. Visita";
        Planif2: Record "Promotor - Planif. Visita";
        Text001: Label 'The planning has been posted';
        Promotor: Code[20];


    procedure RecibeParametros(CodPromotor: Code[20])
    begin
        Promotor := CodPromotor;
    end;
}

#pragma implicitwith restore

