codeunit 76000 "Anular nómina (disponible)"
{
    Permissions = TableData "Historico Cab. nomina" = rimd,
                  TableData "Historico Lin. nomina" = rimd;
    TableNo = "Historico Cab. nomina";

    trigger OnRun()
    begin
        GlobalRec.Copy(Rec);
        if GlobalRec."No. Contabilización" <> '' then
            if not Confirm('Ya está contabilizada (' + GlobalRec."No. Contabilización" + ').¿Desea anular?') then
                exit;

        if GlobalRec."No. Contabilización" = '' then
            if not Confirm('¿Confirma que desea anular?') then
                exit;
        GlobalRec.Anular;

        Rec.Copy(GlobalRec);
    end;

    var
        ok: Boolean;
        RegCooncep: Record "Conceptos salariales";
        "Lín.nómina": Record "Historico Lin. nomina";
        "Lín.esquema": Record "Perfil Salarial";
        "Cab.esquema": Record "Tipos de acciones personal";
        diascotiz: Integer;
        RegTrab: Record Employee;
        PagaExtra: Decimal;
        SiNo: Boolean;
        "añoActual": Integer;
        fechai: Date;
        fechaf: Date;
        "díasAño": Integer;
        copiar: Boolean;
        "hayLín": Boolean;
        GlobalRec: Record "Historico Cab. nomina";
        Window: Dialog;


    procedure CODIGO()
    var
        CabAporteEmp: Record "Cab. Aportes Empresas";
        LinAporteEmp: Record "Lin. Aportes Empresas";
        Msj: Text;
    begin
        Msj := 'Borrar una nómina del histórico     \\' +
                      'Mes                   %1  \' +
                      'Tipo                  %2  \';

        //Cambia Dialog por Confirm para poder recibir un valor 
        /*Window.Open(
          'Borrar una nómina del histórico     \\' +
          'Mes                   #1######## \' +
          'Tipo                  #2######## \' +
          'Copiar a esq.Simul    #3######## \\' +
          'Yes/No                 #4######## \');

        Window.Update(1, Período);
        Window.Update(2, "Tipo de nomina");
        Window.Update(3, copiar);
        Window.Input(3, copiar);
        Window.Update(4, SiNo);
        Window.Input(4, SiNo);*/

        //if SiNo = false then
        if not Confirm(Msj, false, GlobalRec."Período", GlobalRec."Tipo de nomina") then
            exit;

        GlobalRec.LockTable;

        if GlobalRec."No. Contabilización" <> '' then
            if not Confirm('Ya está contabilizada (' + GlobalRec."No. Contabilización" + ').¿Desea anular?') then
                exit;

        "Lín.nómina".Reset;
        //  "Lín.nómina".SETRANGE("No. Documento","No. Documento");
        "Lín.nómina".SetRange("No. empleado", GlobalRec."No. empleado");
        "Lín.nómina".SetRange(Período, GlobalRec.Período);
        "Lín.nómina".SetRange("Tipo Nómina", GlobalRec."Tipo Nomina");
        "Lín.nómina".DeleteAll;

        //LinAporteEmp.SETRANGE("No. Documento","No. Documento");
        LinAporteEmp.SetRange(Período, GlobalRec.Período);
        //LinAporteEmp.SETRANGE("No. Empleado","No. empleado");
        LinAporteEmp.DeleteAll;
        GlobalRec.Delete;
    end;
}

