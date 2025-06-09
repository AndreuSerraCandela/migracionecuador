#pragma implicitwith disable
page 76200 "Empresas de cotización"
{
    ApplicationArea = all;
    PageType = Card;
    SourceTable = "Empresas Cotizacion";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Empresa cotizacion"; rec."Empresa cotizacion")
                {
                }
                field("Nombre Empresa cotizacinn"; rec."Nombre Empresa cotizacinn")
                {
                }
                field(Direccion; rec.Direccion)
                {
                    Caption = 'Dirección';
                }
                field(Numero; rec.Numero)
                {
                    Caption = 'Apartamento';
                }
                field(Municipio; rec.Municipio)
                {
                }
                field(Provincia; rec.Provincia)
                {
                }
                field("Cód. país"; rec."Cód. país")
                {
                }
                field("Codigo Postal"; rec."Codigo Postal")
                {
                    Caption = 'C.P + Población';
                }
                field("Domicilio fiscal"; rec."Domicilio fiscal")
                {
                }
                field("Tipo de documento"; rec."Tipo de documento")
                {
                }
                field("RNC/CED"; rec."RNC/CED")
                {
                }
                field(Imagen; rec.Imagen)
                {
                }
                field("Teléfono"; rec.Teléfono)
                {
                }
                field(Fax; rec.Fax)
                {
                }
                field("E-Mail"; rec."E-Mail")
                {
                }
                field("Esquema percepción"; rec."Esquema percepción")
                {
                }
                field("Tasa de Riesgo (%)"; rec."Tasa de Riesgo (%)")
                {
                }
                field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; rec."Global Dimension 2 Code")
                {
                }
                field("Tipo Empresa de Trabajo"; rec."Tipo Empresa de Trabajo")
                {
                }
            }
            group(Taxes)
            {
                Caption = 'Taxes';
                field("ID RNL"; rec."ID RNL")
                {
                }
                field("ID TSS"; rec."ID TSS")
                {
                }
            }
            group(Payments)
            {
                Caption = 'Payments';
                field("ID  Volante Pago"; rec."ID  Volante Pago")
                {
                }
                field("Forma de Pago"; rec."Forma de Pago")
                {
                }
                field(Banco; rec.Banco)
                {
                }
                field(Cuenta; rec.Cuenta)
                {
                }
                field("Tipo Pago Nomina"; rec."Tipo Pago Nomina")
                {
                }
                field("Identificador Empresa"; rec."Identificador Empresa")
                {
                }
                field("Path archivo Nomina"; rec."Path archivo Nomina")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Empresa Cotizacion")
            {
                Caption = '&Empresa Cotizacion';
                Visible = true;
                action("Employee list")
                {
                    Caption = 'Employee list';
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = Page "Employee List";
                    RunPageLink = Company = FIELD("Empresa cotizacion");
                }
                action("Copy from Company Setup")
                {
                    Caption = 'Copy from Company Setup';
                    Image = Copy;

                    trigger OnAction()
                    var
                        CompanySetup: Record "Company Information";
                    begin
                        if not Confirm(Text001, true) then
                            exit;

                        CompanySetup.Get();
                        Rec."Nombre Empresa cotizacinn" := CompanySetup.Name;
                        Rec.Direccion := CompanySetup.Address;
                        Rec."Teléfono" := CompanySetup."Phone No.";
                        Rec.Imagen := CompanySetup.Picture;
                        Rec.Fax := CompanySetup."Fax No.";
                        Rec."RNC/CED" := CompanySetup."VAT Registration No.";
                        Rec."Codigo Postal" := CompanySetup."Post Code";
                        Rec.Municipio := CompanySetup."Address 2";
                        Rec.Provincia := CompanySetup.City;
                        CompanySetup.CalcFields(Picture);
                        Rec.Imagen := CompanySetup.Picture;
                        if not Rec.Insert then
                            Rec.Modify;
                    end;
                }
                action(Comments)
                {
                    Caption = 'Comments';
                    Image = ViewComments;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Comentarios nóminas";
                    RunPageLink = Tipo = CONST("Empresa cotización"),
                                  Codigo = FIELD("Empresa cotizacion");
                }
            }
            group("&Otros datos")
            {
                Caption = '&Otros datos';
                action("Work Centers")
                {
                    Caption = 'Work Centers';
                    Image = WorkCenter;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Ficha Centros de Trabajo";
                    RunPageLink = "Empresa cotización" = FIELD("Empresa cotizacion");
                }
                action("Legal representatives")
                {
                    Caption = 'Legal representatives';
                    Image = ContactPerson;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = Page "Representantes Empresas";
                    RunPageLink = "Empresa cotización" = FIELD("Empresa cotizacion");
                }
            }
        }
    }

    var
        Text001: Label 'Do you confirm you want to copy the information from the Company setup?';
}

#pragma implicitwith restore

