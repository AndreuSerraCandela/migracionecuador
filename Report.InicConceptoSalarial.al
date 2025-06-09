report 76037 "Inic. Concepto Salarial"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Perfil Salarial"; "Perfil Salarial")
        {
            DataItemTableView = SORTING("Perfil salarial", "Sujeto Cotizacion", "No. empleado");

            trigger OnAfterGetRecord()
            begin

                if ConfNom."Concepto Sal. Base" <> "Concepto salarial" then begin
                    if InicImporte then
                        Importe := 0;

                    if InicCantidad then
                        Cantidad := 0;

                    Modify;
                end;
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Concepto salarial", Concepto);
                ConfNom.Get();
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("concepto salarial"; Concepto)
                {
                    TableRelation = "Conceptos salariales";
                    applicationarea = All;
                }
                field("Inicializa cantidad"; InicCantidad)
                {
                    ApplicationArea = All;
                }
                field("Inicializa importes"; InicImporte)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if Concepto = '' then
                            Error(Err002);

                        rLinEsqPercepcion.SetRange("Concepto salarial", Concepto);
                        if rLinEsqPercepcion.FindFirst then
                            if (rLinEsqPercepcion."Formula calculo" <> '') and (InicImporte) then
                                Error(Err001);
                    end;
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
        InicCantidad: Boolean;
        InicImporte: Boolean;
        Concepto: Code[20];
        rLinEsqPercepcion: Record "Perfil Salarial";
        Err001: Label 'This Wage concept has a Formula, it can''t be cleared';
        Err002: Label 'You must select a Wage concept';
        ConfNom: Record "Configuracion nominas";
}

