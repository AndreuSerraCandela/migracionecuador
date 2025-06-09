table 55013 "Log comprobantes electronicos"
{
    // #35029,  RRT, 22.03.2018: Creación del campo "Desde interfaz usuario".
    // #203574, RRT, 01.04.2019: Añadir los valores "Inicio proceso" e "Inicio envio" al campo "Estado" para auditar mejor el proceso de envio.

    Caption = 'Log comprobantes electrónicos';

    fields
    {
        field(10; "No. mov."; Integer)
        {
            Caption = 'Nº mov.';
        }
        field(20; "Fecha hora mov."; DateTime)
        {
            Caption = 'Fecha hora mov.';
        }
        field(30; Usuario; Code[50])
        {
            Caption = 'Usuario';
        }
        field(40; Ambiente; Option)
        {
            Caption = 'Ambiente';
            OptionCaption = 'Pruebas,Producción';
            OptionMembers = Pruebas,Produccion;
        }
        field(50; "Fichero XML"; Text[250])
        {
            Caption = 'Fichero XML / Clave';
        }
        field(60; "Tipo documento"; Option)
        {
            Caption = 'Tipo documento';
            OptionCaption = 'Factura,Justificante de retención,Remisión,Nota de crédito, Nota de débito';
            OptionMembers = Factura,Retencion,Remision,NotaCredito,NotaDebito;
        }
        field(70; "No. documento"; Code[20])
        {
            Caption = 'Nº documento';
        }
        field(80; Estado; Option)
        {
            Caption = 'Estado';
            OptionCaption = 'Generado,Firmado,Enviado,Rechazado,Autorizado,No autorizado,Error,Emitido en contingencia,Inicio Proceso,Inicio envio';
            OptionMembers = Generado,Firmado,Enviado,Rechazado,Autorizado,"No autorizado",Error,Contingencia,"Inicio proceso","Inicio envio";
        }
        field(90; "Respuesta SRI"; Text[250])
        {
            Caption = 'Respuesta SRI';
        }
        field(100; "Info adicional"; Text[250])
        {
            Caption = 'Info adicional';
        }
        field(101; "Desde interfaz usuario"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "No. mov.")
        {
            Clustered = true;
        }
        key(Key2; "Tipo documento", "No. documento")
        {
        }
        key(Key3; "No. documento", Estado)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var

    begin
        "No. mov." := TraerUltimo + 1;


    end;


    procedure TraerUltimo(): Integer
    var
        recLog: Record "Log comprobantes electronicos";
    begin
        if recLog.FindLast then
            exit(recLog."No. mov.");
    end;
}

