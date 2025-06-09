table 76047 "Turnos TPV"
{
    Caption = 'Control de TPV';
    DrillDownPageID = "Subform turnos TPV";
    LookupPageID = "Subform turnos TPV";

    fields
    {
        field(10; "No. tienda"; Code[20])
        {
            Caption = 'Nº tienda';
            TableRelation = Tiendas;
        }
        field(20; "No. TPV"; Code[20])
        {
            Caption = 'Nº TPV';
            TableRelation = "Configuracion TPV"."Id TPV" WHERE(Tienda = FIELD("No. tienda"));
        }
        field(30; Fecha; Date)
        {
            Caption = 'Fecha';
        }
        field(40; "No. turno"; Integer)
        {
            Caption = 'Nº turno';
        }
        field(60; "Hora apertura"; Time)
        {
            Caption = 'Hora apertura';
        }
        field(70; "Usuario apertura"; Code[20])
        {
            Caption = 'Usuario apertura';
        }
        field(90; "Hora cierre"; Time)
        {
            Caption = 'Hora cierre';
        }
        field(100; "Usuario cierre"; Code[20])
        {
            Caption = 'Usuario cierre';
        }
        field(110; "Nombre tienda"; Text[200])
        {
            CalcFormula = Lookup(Tiendas.Descripcion WHERE("Cod. Tienda" = FIELD("No. tienda")));
            Caption = 'Nombre tienda';
            FieldClass = FlowField;
        }
        field(120; "Nombre TPV"; Text[200])
        {
            CalcFormula = Lookup("Configuracion TPV"."Id TPV" WHERE(Tienda = FIELD("No. tienda"),
                                                                     "Id TPV" = FIELD("No. TPV")));
            Caption = 'Nombre TPV';
            FieldClass = FlowField;
        }
        field(130; Estado; Option)
        {
            Caption = 'Estado';
            OptionCaption = 'Cerrado,Abierto';
            OptionMembers = Cerrado,Abierto;
        }
        field(140; "Fondo de caja"; Decimal)
        {
            CalcFormula = Lookup("Transacciones Caja TPV"."Importe (DL)" WHERE("Cod. tienda" = FIELD("No. tienda"),
                                                                                "Cod. TPV" = FIELD("No. TPV"),
                                                                                Fecha = FIELD(Fecha),
                                                                                "No. turno" = FIELD("No. turno"),
                                                                                "Tipo transaccion" = CONST(Fondo)));
            FieldClass = FlowField;
        }
        field(76315; "Id Replicacion"; Code[20])
        {
            Description = 'DsPOS Standard';
        }
    }

    keys
    {
        key(Key1; "No. tienda", "No. TPV", Fecha, "No. turno")
        {
            Clustered = true;
        }
        key(Key2; "Id Replicacion")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        recArqueo: Record "Arqueo de caja";
    begin
    end;

    trigger OnInsert()
    begin
        "No. turno" := TraerUltimoTurno + 1;
        CopiarFormasPagoDeclaracion;

        "Id Replicacion" := StrSubstNo('%1', Date2DMY(Fecha, 1)) + StrSubstNo('%1', Date2DMY(Fecha, 2)) + StrSubstNo('%1', Date2DMY(Fecha, 3));
    end;

    var
        Error001: Label 'El TPV %1 de la tienda %2 esta cerrado.';


    procedure TraerUltimoTurno(): Integer
    var
        recControl: Record "Turnos TPV";
    begin
        recControl.Reset;
        recControl.SetRange("No. tienda", "No. tienda");
        recControl.SetRange("No. TPV", "No. TPV");
        recControl.SetRange(Fecha, Fecha);
        if recControl.FindLast then
            exit(recControl."No. turno");
    end;


    procedure ActualizarFondoCaja(codPrmUsuario: Code[20]; decPrmFondo: Decimal)
    var
        recTrans: Record "Transacciones Caja TPV";
    /*    cduComun: Codeunit "Funciones DsPOS - Comunes"; */
    begin
        recTrans.Reset;
        recTrans.SetRange("Cod. tienda", "No. tienda");
        recTrans.SetRange("Cod. TPV", "No. TPV");
        recTrans.SetRange(Fecha, Fecha);
        recTrans.SetRange("No. turno", "No. turno");
        recTrans.SetRange("Tipo transaccion", recTrans."Tipo transaccion"::Fondo);
        if recTrans.FindFirst then begin
            recTrans.Fecha := WorkDate;
            recTrans.Hora := FormatTime(Time);
            recTrans."Id. cajero" := codPrmUsuario;
            recTrans.Importe := decPrmFondo;
            recTrans."Importe (DL)" := decPrmFondo;
            recTrans.Modify;
        end
        else begin
            recTrans.Init;
            recTrans."Cod. tienda" := "No. tienda";
            recTrans."Cod. TPV" := "No. TPV";
            recTrans.Fecha := Fecha;
            recTrans."No. turno" := "No. turno";
            recTrans."Tipo transaccion" := recTrans."Tipo transaccion"::Fondo;
            recTrans."Id. cajero" := codPrmUsuario;
            recTrans.Fecha := WorkDate;
            recTrans.Hora := FormatTime(Time);
            /*             recTrans."Forma de pago" := cduComun.Efectivo_Local; */
            recTrans.Importe := decPrmFondo;
            recTrans."Importe (DL)" := decPrmFondo;
            recTrans.Insert(true);
        end;
    end;


    procedure TraerFondoCaja(): Decimal
    var
        recTrans: Record "Transacciones Caja TPV";
    begin
        recTrans.Reset;
        recTrans.SetRange("Cod. tienda", "No. tienda");
        recTrans.SetRange("Cod. TPV", "No. TPV");
        recTrans.SetRange(Fecha, Fecha);
        recTrans.SetRange("No. turno", "No. turno");
        recTrans.SetRange("Tipo transaccion", recTrans."Tipo transaccion"::Fondo);
        if recTrans.FindFirst then
            exit(recTrans.Importe);
    end;


    procedure CopiarFormasPagoDeclaracion()
    var
        recFormaPago: Record "Formas de Pago";
        recTPV: Record "Configuracion TPV";
        recBotones: Record Botones;
    begin
        recFormaPago.Reset;
        recFormaPago.SetRange("Efectivo Local", true);
        if recFormaPago.FindFirst then
            InsertarLinDeclaracion(recFormaPago."ID Pago");

        recFormaPago.Reset;
        recFormaPago.SetFilter("Tipo Tarjeta", '<>%1', recFormaPago."Tipo Tarjeta");
        if recFormaPago.FindSet then
            repeat
                InsertarLinDeclaracion(recFormaPago."ID Pago");
            until recFormaPago.Next = 0;

        //Formas de pago configuradas en el TPV
        recTPV.Get("No. tienda", "No. TPV");
        recTPV.TestField("Menu de Formas de Pago");

        recBotones.Reset;
        recBotones.SetRange("ID Menu", recTPV."Menu de Formas de Pago");
        recBotones.SetFilter(Pago, '<>%1', '');
        if recBotones.FindSet then
            repeat
                InsertarLinDeclaracion(recBotones.Pago);
            until recBotones.Next = 0;
    end;


    procedure InsertarLinDeclaracion(codPrmFormaPago: Code[20])
    var
        recLinDeclara: Record "Lin. declaracion caja";
    begin
        if not recLinDeclara.Get("No. tienda", "No. TPV", Fecha, "No. turno", codPrmFormaPago) then begin
            recLinDeclara.Init;
            recLinDeclara."No. tienda" := "No. tienda";
            recLinDeclara."No. TPV" := "No. TPV";
            recLinDeclara.Fecha := Fecha;
            recLinDeclara."No. turno" := "No. turno";
            recLinDeclara.Validate("Forma de pago", codPrmFormaPago);
            recLinDeclara.Insert(true);
        end;
    end;


    procedure FormatTime(timEntrada: Time): Time
    var
        texHora: Text;
        timSalida: Time;
    begin
        texHora := Format(timEntrada);
        Evaluate(timSalida, texHora);
        exit(timSalida);
    end;


    procedure TraerDescuadreTurno(): Decimal
    var
        recDecCaja: Record "Lin. declaracion caja";
        decDescuadre: Decimal;
        rformasPago: Record "Formas de Pago";
    begin
        recDecCaja.Reset;
        recDecCaja.SetRange("No. tienda", "No. tienda");
        recDecCaja.SetRange("No. TPV", "No. TPV");
        recDecCaja.SetRange(Fecha, Fecha);
        recDecCaja.SetRange("No. turno", "No. turno");
        if recDecCaja.FindSet then
            repeat
                rformasPago.Get(recDecCaja."Forma de pago");
                if rformasPago."Realizar recuento" then
                    decDescuadre += recDecCaja.TraerDiferencia;
            until recDecCaja.Next = 0;
        exit(decDescuadre);
    end;
}

