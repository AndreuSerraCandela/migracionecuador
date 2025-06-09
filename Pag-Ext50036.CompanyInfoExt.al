pageextension 50036 CompanyInfoExt extends "Company Information"
{
    layout
    {
        addafter(Communication)
        {
            group(SRI)
            {
                Caption = 'SRI';

                field("Identificación del Rep. Legal"; rec."Identificación del Rep. Legal")
                {
                    ApplicationArea = All;
                    ToolTip = 'Identificación del Representante Legal de la empresa.';
                    Caption = 'Identificación del Rep. Legal';
                }
                field("RUC del Contador"; rec."RUC del Contador")
                {
                    ApplicationArea = All;
                    ToolTip = 'RUC del Contador de la empresa.';
                    Caption = 'RUC del Contador';
                }
                field("Cod. contribuyente especial"; rec."Cod. contribuyente especial")
                {
                    ApplicationArea = All;
                    ToolTip = 'Código del contribuyente especial de la empresa.';
                    Caption = 'Cod. contribuyente especial';
                }
                field("Código otorgado por DINARDAP"; rec."Código otorgado por DINARDAP")
                {
                    ApplicationArea = All;
                    ToolTip = 'Código otorgado por DINARDAP a la empresa.';
                    Caption = 'Código otorgado por DINARDAP';
                }
                field("No. Establecimientos inscritos"; rec."No. Establecimientos inscritos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Número de establecimientos inscritos de la empresa.';
                    Caption = 'No. Establecimientos inscritos';
                }
            }
        }
    }
}