#pragma implicitwith disable
page 76223 "Ficha Miembros Coop."
{
    ApplicationArea = all;
    PageType = Card;
    SourceTable = "Miembros cooperativa";

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = editar;
                field("Tipo de miembro"; rec."Tipo de miembro")
                {
                }
                field("Employee No."; rec."Employee No.")
                {
                }
                field("Full name"; rec."Full name")
                {
                }
                field("Fecha inscripcion"; rec."Fecha inscripcion")
                {
                }
                field("Tipo de aporte"; rec."Tipo de aporte")
                {
                }
                field(Importe; rec.Importe)
                {
                }
                field("1ra Quincena"; rec."1ra Quincena")
                {
                }
                field("2da Quincena"; rec."2da Quincena")
                {
                }
                field("Ahorro acumulado"; rec."Ahorro acumulado")
                {
                }
                field("Prestamos pendientes"; rec."Prestamos pendientes")
                {
                }
                field("Importe pendiente"; rec."Importe pendiente")
                {
                }
                field(Status; rec.Status)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Calendar")
            {
                Caption = '&Calendar';
                action(Activate)
                {
                    Caption = 'Activate';
                    Enabled = not BtActivo;
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ConceptosSalariales: Record "Conceptos salariales";
                        PerfilSal: Record "Perfil Salarial";
                    begin
                        /*
                        ConfNomina.GET();
                        ConfNomina.TESTFIELD("Concepto Cuota cooperativa");
                        Status := 1;
                        
                        PerfilSal.RESET;
                        PerfilSal.SETRANGE("No. empleado","Employee No.");
                        PerfilSal.SETRANGE("Concepto salarial",ConfNomina."Concepto Cuota cooperativa");
                        IF NOT PerfilSal.FINDFIRST THEN
                          BEGIN
                            PerfilSal.INIT;
                            PerfilSal.VALIDATE("No. empleado","Employee No.");
                            PerfilSal.VALIDATE("Concepto salarial",ConfNomina."Concepto Cuota cooperativa");
                            PerfilSal.INSERT(TRUE);
                          END;
                        COMMIT;
                        CASE "Tipo de aporte" OF
                          "Tipo de aporte"::Fijo:
                            BEGIN
                              TESTFIELD(Importe);
                              PerfilSal.Cantidad := 1;
                              PerfilSal.Importe := Importe;
                            END
                          ELSE
                            BEGIN
                              TESTFIELD(Importe);
                              PerfilSal.Cantidad := 1;
                              PerfilSal."Fórmula cálculo" := ConfNomina."Concepto Sal. Base" + '*' +  FORMAT(Importe / 100);
                              PerfilSal.VALIDATE("Fórmula cálculo");
                            END;
                        END;
                        PerfilSal."1ra Quincena" := TRUE;
                        PerfilSal."2da Quincena" := TRUE;
                        PerfilSal.MODIFY;
                        MODIFY;
                        
                        MESSAGE(Msg001);
                        */

                        Funcionescooperativa.ActivarMiembro(Rec);

                    end;
                }
                action(Inactivate)
                {
                    Caption = 'Inactivate';
                    Enabled = BtActivo;
                    Image = CancelLine;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ConceptosSalariales: Record "Conceptos salariales";
                        PerfilSal: Record "Perfil Salarial";
                    begin
                        /*ConfNomina.GET();
                        ConfNomina.TESTFIELD("Concepto Cuota cooperativa");
                        Status := 2;
                        
                        PerfilSal.RESET;
                        PerfilSal.SETRANGE("No. empleado","Employee No.");
                        PerfilSal.SETRANGE("Concepto salarial",ConfNomina."Concepto Cuota cooperativa");
                        PerfilSal.FINDFIRST;
                        
                        PerfilSal.Cantidad := 0;
                        PerfilSal.MODIFY;
                        MODIFY;
                        
                        MESSAGE(Msg002);
                        */
                        Funcionescooperativa.InActivarMiembro(Rec);

                    end;
                }
                action(Retire)
                {
                    Caption = 'Retire';
                    Enabled = BtActivo;
                    Image = Archive;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ConceptosSalariales: Record "Conceptos salariales";
                        PerfilSal: Record "Perfil Salarial";
                    begin
                        Funcionescooperativa.RetirarMiembro(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        Editar := not (Rec.Status <> Rec.Status::" ");
        BtActivo := not Editar;
    end;

    var
        ConfNomina: Record "Configuracion nominas";
        Msg001: Label 'Successful employee activation';
        Msg002: Label 'Successful employee inactivation';
        Funcionescooperativa: Codeunit "Funciones cooperativa";
        Editar: Boolean;
        BtActivo: Boolean;
}

#pragma implicitwith restore

