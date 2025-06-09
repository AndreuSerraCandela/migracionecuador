table 76022 "Log procesos TPV"
{
    // #121213, RRT, 12.03.2018: Se añade el valor "Eliminar linea" el campo "ID Proceso". De esta forma podrá quedar auditado quien y cuando elimina una línea de factura.
    // #328529, RRT, 05.08.2020: Se auditará la aplicación de cupones con el fin de prevenir problemas de concurrencia en el mismo cupón.
    // #348662  RRT, 25.11.2020: Actualizar DS-POS para ajustar a version 43c. Redenominar tambien campos con caracteres conflictivos.
    // 
    // #373762  RRT, 09.04.2021:
    //          #369900, RRT, 07.04.2021: Añadir el total de la factura y de los pagos al registrar una factura.
    // 
    // #381937  RRT, 01.06.2021: Auditar la creación de devoluciones.


    fields
    {
        field(1; "No. Log"; Integer)
        {
        }
        field(2; "ID Proceso"; Option)
        {
            OptionMembers = Registrar,"Nueva Venta","Anular Factura","Eliminar Linea",Duplicacion,Serie,"Cambio Almacen",Cupon,"Crear Devolucion";
        }
        field(3; "Punto de proceso"; Integer)
        {
            Description = 'Este valor, identifica el último punto de proceso realizado. Su valor se refleja en el código.';
        }
        field(10; "Tipo Documento"; Option)
        {
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(11; "ID. Cab Venta"; Code[20])
        {
        }
        field(12; "ID. Historico"; Code[20])
        {
        }
        field(14; "No. Fiscal TPV"; Code[50])
        {
            TableRelation = Tiendas;
        }
        field(15; "No. comprobante fiscal"; Code[50])
        {
            TableRelation = "Configuracion TPV"."Id TPV";
        }
        field(19; "Texto Error"; Text[150])
        {
        }
        field(20; Tienda; Code[20])
        {
            TableRelation = Tiendas;
        }
        field(21; TPV; Code[20])
        {
            TableRelation = "Configuracion TPV"."Id TPV";
        }
        field(25; Cupon; Code[20])
        {
            Description = '#328529 - El Salvador';
        }
        field(30; "Fecha creacion"; Date)
        {
        }
        field(31; "Hora creacion"; Time)
        {
        }
        field(32; Usuario; Text[50])
        {
        }
        field(33; "Fecha modificacion"; Date)
        {
        }
        field(34; "Hora modificacion"; Time)
        {
        }
        field(40; "Total factura"; Decimal)
        {
            Description = '#369900';
        }
        field(41; "Total transaccion"; Decimal)
        {
            Description = '#369900';
        }
        field(42; "Total pagos"; Decimal)
        {
            Description = '#369900';
        }
        field(43; "Total pagos v2"; Decimal)
        {
            Description = '#369900';
        }
    }

    keys
    {
        key(Key1; "No. Log")
        {
            Clustered = true;
        }
        key(Key2; Tienda, TPV, Cupon)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        rLog: Record "Log procesos TPV";
    begin
        rLog.Reset;
        rLog.SetCurrentKey("No. Log");
        if rLog.FindLast then
            "No. Log" := rLog."No. Log" + 1
        else
            "No. Log" := 1;

        "Fecha creacion" := Today;
        "Hora creacion" := Time;
        Usuario := CopyStr(UserId, 1, MaxStrLen(Usuario));
    end;

    trigger OnModify()
    var
        lrCV: Record "Sales Header";
        lrSIH: Record "Sales Invoice Header";
        lrSCMH: Record "Sales Cr.Memo Header";
        lrTransCaja: Record "Transacciones Caja TPV";
        lrPagos: Record "Pagos TPV";
        lrPagos_2: Record "Pagos TPV";
        lImporteDoc: Decimal;
        lInfoImportes: Boolean;
    begin
        "Fecha modificacion" := Today;
        "Hora modificacion" := Time;


        //+#369900
        lInfoImportes := false;

        if (("ID Proceso" = "ID Proceso"::Registrar) and (("Punto de proceso" = 14) or ("Punto de proceso" = 8))) or
           (("ID Proceso" = "ID Proceso"::"Anular Factura") and (("Punto de proceso" = 12) or ("Punto de proceso" = 7))) then
            lInfoImportes := true;


        if not lInfoImportes then
            exit;



        lImporteDoc := 0;
        //... Calculamos el importe de la factura o devolucion.
        if lrCV.Get("Tipo Documento", "ID. Cab Venta") then begin
            lrCV.CalcFields("Amount Including VAT");
            lImporteDoc := lrCV."Amount Including VAT";
        end
        else begin
            case "Tipo Documento" of
                "Tipo Documento"::Invoice:
                    begin
                        if lrSIH.Get("ID. Historico") then begin
                            lrSIH.CalcFields("Amount Including VAT");
                            lImporteDoc := lrSIH."Amount Including VAT";
                        end;
                    end;

                "Tipo Documento"::"Credit Memo":
                    begin
                        if lrSCMH.Get("ID. Historico") then begin
                            lrSCMH.CalcFields("Amount Including VAT");
                            lImporteDoc := lrSCMH."Amount Including VAT";
                        end;
                    end;

            end;
        end;

        //... Calculamos el importe de la transaccion.
        if "ID. Historico" <> '' then begin
            lrTransCaja.Reset;
            lrTransCaja.SetCurrentKey("No. Registrado");
            lrTransCaja.SetRange("No. Registrado", "ID. Historico");
            lrTransCaja.CalcSums(Importe);
        end;

        //... Calculamos el importe de los pagos.
        if "ID. Cab Venta" <> '' then begin
            lrPagos.Reset;
            lrPagos.SetCurrentKey("No. Borrador");
            lrPagos.SetRange("No. Borrador", "ID. Cab Venta");
            lrPagos.CalcSums(Importe);
        end;

        //... Calculamos el importe de los pagos con el filtro de registrado TPV
        if "ID. Cab Venta" <> '' then begin
            lrPagos_2.Reset;
            lrPagos_2.SetCurrentKey("No. Borrador");
            lrPagos_2.SetRange("No. Borrador", "ID. Cab Venta");
            lrPagos_2.SetRange("Registrado TPV", true);
            lrPagos_2.CalcSums(Importe);
        end;

        "Total factura" := lImporteDoc;
        "Total transaccion" := lrTransCaja.Importe;
        "Total pagos" := lrPagos.Importe;
        "Total pagos v2" := lrPagos_2.Importe;
    end;
}

