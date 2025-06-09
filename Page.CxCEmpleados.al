#pragma implicitwith disable
page 76164 "CxC Empleados"
{
    ApplicationArea = all;
    PageType = Card;
    SourceTable = "CxC Empleados";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No. Préstamo"; rec."No. Préstamo")
                {

                    trigger OnAssistEdit()
                    begin
                        if Rec.AsistEdic(xRec) then
                            CurrPage.Update;
                    end;
                }
                field("Código Empleado"; rec."Código Empleado")
                {
                }
                field("Tipo CxC"; rec."Tipo CxC")
                {
                }
                field("Motivo Prestamos"; rec."Motivo Prestamos")
                {
                }
                field("Fecha Registro CxC"; rec."Fecha Registro CxC")
                {
                }
                field(Importe; rec.Importe)
                {
                }
                field(Documento; rec."No. Documento")
                {
                }
                field(Cuotas; rec.Cuotas)
                {
                }
                field("Importe Cuota"; rec."Importe Cuota")
                {
                }
                field("Nro. Solicitud CK"; rec."Nro. Solicitud CK")
                {
                }
                field("Cta. Contrapartida"; rec."Cta. Contrapartida")
                {
                }
                field("Fecha Inicio Deducción"; rec."Fecha Inicio Deducción")
                {
                }
                field("Concepto Salarial"; rec."Concepto Salarial")
                {
                }
                field("1ra Quincena"; rec."1ra Quincena")
                {
                }
                field("2da Quincena"; rec."2da Quincena")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Empleado")
            {
                Caption = '&Empleado';
                action("&Movimientos CxC Empleados")
                {
                    Caption = '&Movimientos CxC Empleados';
                    Visible = false;
                }
            }
            group("&Registro")
            {
                Caption = '&Registro';
                action(Post)
                {
                    Caption = 'Post';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        Answer := Confirm(Text001, false);
                        if Answer = true then
                            if Rec."No. Préstamo" = '' then
                                Error(StrSubstNo(Err001, Rec."No. Préstamo"))
                            else begin
                                Rec.TestField("Fecha Registro CxC");
                                Rec.TestField("Fecha Inicio Deducción");
                                Rec.TestField("Concepto Salarial");
                                HistCabPrestamo.Reset;
                                HistCabPrestamo.Validate("No. Préstamo");
                                HistCabPrestamo."Employee No." := Rec."Código Empleado";
                                HistCabPrestamo."Fecha Registro CxC" := Rec."Fecha Registro CxC";
                                HistCabPrestamo."Fecha Inicio Deducción" := Rec."Fecha Inicio Deducción";
                                HistCabPrestamo."Tipo CxC" := Rec."Tipo CxC";
                                HistCabPrestamo.Cuotas := Rec.Cuotas;
                                HistCabPrestamo."Tipo Contrapartida" := Rec."Tipo Contrapartida";
                                HistCabPrestamo."Cta. Contrapartida" := Rec."Cta. Contrapartida";
                                HistCabPrestamo."Nro. Solicitud CK" := Rec."Nro. Solicitud CK";
                                HistCabPrestamo."No. Documento" := Rec."No. Documento";
                                HistCabPrestamo.Pendiente := true;
                                HistCabPrestamo."% Cuota" := Rec."% a deducir de Ingresos";
                                HistCabPrestamo."No. Mov. Cliente" := Rec."No. Mov. Cliente";
                                HistCabPrestamo."1ra Quincena" := Rec."1ra Quincena";
                                HistCabPrestamo."2da Quincena" := Rec."2da Quincena";
                                HistCabPrestamo."Importe Cuota" := Rec."Importe Cuota";
                                HistCabPrestamo."Concepto Salarial" := Rec."Concepto Salarial";
                                HistCabPrestamo.Insert;

                                HistLinPrestamo.Reset;
                                HistLinPrestamo."No. Préstamo" := HistCabPrestamo."No. Préstamo";
                                HistLinPrestamo."No. Línea" += 100;
                                HistLinPrestamo."Tipo CxC" := Rec."Tipo CxC";
                                HistLinPrestamo."No. Cuota" := 0;
                                HistLinPrestamo."Fecha Transacción" := Rec."Fecha Registro CxC";
                                HistLinPrestamo."Código Empleado" := Rec."Código Empleado";
                                HistLinPrestamo.Débito := Rec.Importe;
                                HistLinPrestamo.Validate(Débito);
                                HistLinPrestamo.Insert;
                                Clear(HistCabPrestamo);
                                Clear(HistLinPrestamo);
                                Rec.Delete;
                            end;
                    end;
                }
            }
        }
        area(processing)
        {
            action("Calculate fees")
            {
                Caption = 'Calculate fees';
                Image = CalculateDiscount;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Rec."Importe Cuota" := Rec.Importe / Rec.Cuotas;
                    CurrPage.Update;
                end;
            }
        }
    }

    var
        rCxCEmpl: Record "CxC Empleados";
        dCuotas: Decimal;
        HistCabPrestamo: Record "Histórico Cab. Préstamo";
        HistLinPrestamo: Record "Histórico Lín. Préstamo";
        Answer: Boolean;
        Text001: Label 'Do you watn to post the loan?';
        Err001: Label 'Th field %1 can not be empty';
}

#pragma implicitwith restore

