codeunit 76049 "Modelo recib.salario"
{
    TableNo = "Historico Cab. nomina";

    trigger OnRun()
    begin
        GlobalRec.Copy(Rec);
        Empresa.Get(GlobalRec."Empresa cotización");
        Rec.SetRange("No. empleado", GlobalRec."No. empleado");
        Rec.SetRange(Período, GlobalRec.Período);
        Rec.SetRange("Tipo de nomina", GlobalRec."Tipo de nomina");
        REPORT.RunModal(Empresa."ID  Volante Pago", true, false, Rec);

        Rec.Copy(GlobalRec);
    end;

    var
        Empresa: Record "Empresas Cotizacion";
        GlobalRec: Record "Historico Cab. nomina";
        RepOficial: Report "Payroll invoice report";
        RepMatriz: Report "Recibo form.fact. Dom.";
}

