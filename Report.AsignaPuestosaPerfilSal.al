report 76165 "Asigna Puestos a Perfil Sal."
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Perfil Salario x Cargo"; "Perfil Salario x Cargo")
        {
            DataItemTableView = SORTING ("Puesto de Trabajo", "Concepto salarial", "No. de Orden") WHERE ("Puesto de Trabajo" = CONST ('ASIST ADM'));

            trigger OnAfterGetRecord()
            begin
                Cargo.Find('-');
                repeat
                    RPerfil.TransferFields("Perfil Salario x Cargo");
                    RPerfil.Validate("Puesto de Trabajo", Cargo.Codigo);
                    if RPerfil.Insert then;

                until Cargo.Next = 0;
            end;

            trigger OnPreDataItem()
            begin
                //RPerfil.DELETEALL;
            end;
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

    labels
    {
    }

    var
        Cargo: Record "Puestos laborales";
        Conceptos: Record "Conceptos salariales";
        RPerfil: Record "Perfil Salario x Cargo";
}

