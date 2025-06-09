#pragma implicitwith disable
page 76013 "Conceptos salariales"
{
    ApplicationArea = all;
    DataCaptionFields = Codigo;
    Editable = true;
    PageType = List;
    SourceTable = "Conceptos salariales";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Dimension Nomina"; rec."Dimension Nomina")
                {
                    Visible = false;
                }
                field(Codigo; rec.Codigo)
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("Sujeto Cotizacion"; rec."Sujeto Cotizacion")
                {
                }
                field("Cotiza ISR"; rec."Cotiza ISR")
                {
                }
                field("Cotiza AFP"; rec."Cotiza AFP")
                {
                }
                field("Cotiza SFS"; rec."Cotiza SFS")
                {
                }
                field("Cotiza SRL"; rec."Cotiza SRL")
                {
                }
                field("Cotiza INFOTEP"; rec."Cotiza INFOTEP")
                {
                }
                field("Aplica para Regalia"; rec."Aplica para Regalia")
                {
                }
                field("Tipo concepto"; rec."Tipo concepto")
                {
                }
                field("Salario Base"; rec."Salario Base")
                {
                }
                field(Provisionar; rec.Provisionar)
                {
                }
                field("Validar Contrapartida CO"; rec."Validar Contrapartida CO")
                {
                }
                field("Validar Contrapartida CP"; rec."Validar Contrapartida CP")
                {
                }
                field("Tipo Cuenta Cuota Obrera"; rec."Tipo Cuenta Cuota Obrera")
                {
                }
                field("No. Cuenta Cuota Obrera"; rec."No. Cuenta Cuota Obrera")
                {
                }
                field("Tipo Cuenta Contrapartida CO"; rec."Tipo Cuenta Contrapartida CO")
                {
                }
                field("No. Cuenta Contrapartida CO"; rec."No. Cuenta Contrapartida CO")
                {
                }
                field("Tipo Cuenta Cuota Patronal"; rec."Tipo Cuenta Cuota Patronal")
                {
                }
                field("No. Cuenta Cuota Patronal"; rec."No. Cuenta Cuota Patronal")
                {
                }
                field("Tipo Cuenta Contrapartida CP"; rec."Tipo Cuenta Contrapartida CP")
                {
                }
                field("No. Cuenta Contrapartida CP"; rec."No. Cuenta Contrapartida CP")
                {
                }
                field("Contabilizacion Resumida"; rec."Contabilizacion Resumida")
                {
                }
                field("Contabilizacion x Dimension"; rec."Contabilizacion x Dimension")
                {
                }
                field("Tipo de nomina"; rec."Tipo de nomina")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Action")
            {
                Caption = '&Action';
                action("&Copy All")
                {
                    Caption = '&Copy All';
                    Image = Copy;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        ConfNominas.Get();
                        DimVal.SetRange("Dimension Code", ConfNominas."Dimension Conceptos Salariales");
                        DimVal.SetRange(Blocked, false);
                        if DimVal.Find('-') then
                            repeat
                                Rec."Dimension Nomina" := DimVal."Dimension Code";
                                Rec.Codigo := DimVal.Code;
                                Rec.Descripcion := DimVal.Name;
                                if Rec.Insert then;
                            until DimVal.Next = 0;
                    end;
                }
                separator(Action1000000005)
                {
                }
                action("A&ssign to employees")
                {
                    Caption = 'A&ssign to employees';
                    Image = CopyWorksheet;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        Selection := StrMenu(Text000, 0);
                        PerfilCargo.SetRange("Concepto salarial", Rec.Codigo);
                        if PerfilCargo.Find('-') then
                            repeat
                                if Selection = 2 then begin
                                    PerfilCargo."1ra Quincena" := true;
                                    PerfilCargo."2da Quincena" := false;
                                end
                                else
                                    if Selection = 3 then begin
                                        PerfilCargo."1ra Quincena" := false;
                                        PerfilCargo."2da Quincena" := true;
                                    end
                                    else
                                        if Selection = 4 then begin
                                            PerfilCargo."1ra Quincena" := true;
                                            PerfilCargo."2da Quincena" := true;
                                        end;

                                if not PerfilCargo.Insert then
                                    PerfilCargo.Modify;
                            until PerfilCargo.Next = 0;

                        Empl.Find('-');
                        repeat
                            PerfilSalarial.SetRange("No. empleado", Empl."No.");
                            PerfilSalarial.SetRange("Concepto salarial", Rec.Codigo);
                            if PerfilSalarial.FindFirst then
                                repeat
                                    if Selection = 2 then begin
                                        PerfilSalarial."1ra Quincena" := true;
                                        PerfilSalarial."2da Quincena" := false;
                                    end
                                    else
                                        if Selection = 3 then begin
                                            PerfilSalarial."1ra Quincena" := false;
                                            PerfilSalarial."2da Quincena" := true;
                                        end
                                        else
                                            if Selection = 4 then begin
                                                PerfilSalarial."1ra Quincena" := true;
                                                PerfilSalarial."2da Quincena" := true;
                                            end;
                                    PerfilSalarial.Validate("Concepto salarial");
                                    PerfilSalarial.Modify;
                                until PerfilSalarial.Next = 0
                            else begin
                                PerfilSalarial.Init;
                                PerfilSalarial.Validate("No. empleado", Empl."No.");
                                PerfilSalarial.Validate("Concepto salarial", Rec.Codigo);
                                if Selection = 2 then begin
                                    PerfilSalarial."1ra Quincena" := true;
                                    PerfilSalarial."2da Quincena" := false;
                                end
                                else
                                    if Selection = 3 then begin
                                        PerfilSalarial."1ra Quincena" := false;
                                        PerfilSalarial."2da Quincena" := true;
                                    end
                                    else
                                        if Selection = 4 then begin
                                            PerfilSalarial."1ra Quincena" := true;
                                            PerfilSalarial."2da Quincena" := true;
                                        end;

                                PerfilSalarial.Insert;
                            end;
                        until Empl.Next = 0;
                    end;
                }
                action(Dimensions)
                {
                    Caption = 'Dimentions';
                    Image = Dimensions;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = CONST(76062),
                                  "No." = FIELD(Codigo);
                }
                action("&Prorrated Wedges")
                {
                    Caption = '&Prorrated Wedges';
                    Image = SetupPayment;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Conceptos Salariales Prorrateo";
                    RunPageLink = "Código" = FIELD(Codigo),
                                  "Gpo. Contable Empleado" = CONST('');
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if CurrPage.LookupMode then
            CurrPage.Editable := false;

        ConfNominas.Get();
        Rec.SetRange("Dimension Nomina", ConfNominas."Dimension Conceptos Salariales");
    end;

    var
        ConfNominas: Record "Configuracion nominas";
        DimVal: Record "Dimension Value";
        PerfilCargo: Record "Perfil Salario x Cargo";
        PerfilSalarial: Record "Perfil Salarial";
        Text000: Label '&None,&First,&Second,Both';
        Empl: Record Employee;
        Selection: Integer;
}

#pragma implicitwith restore

