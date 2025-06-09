codeunit 76077 "Utilitario Nominas"
{

    trigger OnRun()
    begin
        //AsignaQuincena;
        LlenaConfigNom;
        //LlenaPerfilEmp;
        AsignaQuincena;
    end;

    var
        Conceptossalariales: Record "Conceptos salariales";
        Puestoslaborales: Record "Puestos laborales";
        Emp: Record Employee;
        PerfilSal: Record "Perfil Salarial";
        PerfilSalarioxCargo: Record "Perfil Salario x Cargo";
        TiposNom: Record "Tipos de nominas";
        HCN: Record "Historico Cab. nomina";
        HCNE: Record "Cab. Aportes Empresas";

    local procedure LlenaDatosConfigPuestos()
    var
        PerfPuesto: Record "Perfil Salario x Cargo";
    begin

        //Para corregir los datos de puestos y departamentos en empleados
        TiposNom.SetRange(Codigo, 'VACACIONES');
        TiposNom.Find('-');
        repeat
            PerfilSal.Reset;
            PerfilSal.SetRange("Tipo de nomina", TiposNom.Codigo);
            if PerfilSal.FindSet then
                repeat
                    PerfilSal."Tipo Nomina" := TiposNom."Tipo de nomina";
                    PerfilSal.Modify;
                until PerfilSal.Next = 0;

            HCN.Reset;
            HCN.SetRange("Tipo de nomina", TiposNom.Codigo);
            if HCN.FindSet then
                repeat
                    HCN."Tipo Nomina" := TiposNom."Tipo de nomina";
                    HCN.Modify;
                until HCN.Next = 0;
            HCNE.Reset;
            HCNE.SetRange("Tipo de nomina", TiposNom.Codigo);
            if HCNE.FindSet then
                repeat
                    HCNE."Tipo Nomina" := TiposNom."Tipo de nomina";
                    HCNE.Modify;
                until HCNE.Next = 0;
        until TiposNom.Next = 0;
    end;

    local procedure LlenaPerfilEmp()
    begin
        Emp.Find('-');
        repeat
            Emp.Validate("Job Type Code");

        until Emp.Next = 0;
    end;

    local procedure AsignaQuincena()
    begin
        PerfilSal.Find('-');
        repeat
            //   PerfilSal."1ra Quincena" := TRUE;
            //  PerfilSal."2da Quincena" := TRUE;
            PerfilSal."Tipo de nomina" := 'MENSUAL';
            PerfilSal.Modify;
        until PerfilSal.Next = 0;
        exit;

        PerfilSalarioxCargo.Find('-');
        repeat
            PerfilSalarioxCargo."1ra Quincena" := true;
            PerfilSalarioxCargo."2da Quincena" := true;
            PerfilSalarioxCargo.Modify;
        until PerfilSalarioxCargo.Next = 0;
    end;

    local procedure LlenaConfigNom()
    var
        PerfilSal: Record "Perfil Salarial";
        Emp: Record Employee;
        Emp2: Record Employee;
        Emp3: Record Employee;
        Depto: Record Departamentos;
        Puestos: Record "Puestos laborales";
        Puestos2: Record "Puestos laborales";
        HistoricoCabnomina: Record "Historico Cab. nomina";
        HistoricoCabnominaOut: Record "Historico Cab. nomina";
        HistoricoLinnomina: Record "Historico Lin. nomina";
        HistoricoLinnominaOut: Record "Historico Lin. nomina";
        CabAportesEmpresas: Record "Cab. Aportes Empresas";
        CabAportesEmpresasOut: Record "Cab. Aportes Empresas";
        LinAportesEmpresas: Record "Lin. Aportes Empresas";
        LinAportesEmpresasOut: Record "Lin. Aportes Empresas";
    begin


        //Primer paso
        /*
        Emp.FIND('-');
        REPEAT
         IF Depto.GET(Emp.Departamento) THEN
            BEGIN
              IF NOT Puestos.GET(Emp.Departamento,Emp."Job Type Code") THEN
                 BEGIN
                  Puestos.RESET;
                  Puestos.SETRANGE(Codigo,Emp."Job Type Code");
                  Puestos.FINDFIRST;
                  Puestos2.TRANSFERFIELDS(Puestos);
                  Puestos2."Cod. departamento" := Emp.Departamento;
                  IF  Puestos2.INSERT THEN
                    COMMIT;
                 END;
            END;
        
        UNTIL Emp.NEXT = 0;
        EXIT;
        */

        /*
        //Segundo paso
        Emp.SETRANGE(Departamento,'');
        Emp.FIND('-');
        REPEAT
          Emp2.RESET;
          Emp2.SETRANGE("Job Type Code",Emp."Job Type Code");
          Emp2.SETFILTER(Departamento,'<>%1','');
          IF Emp2.FINDFIRST THEN
             BEGIN
              Emp3.GET(Emp."No.");
              Emp3.Departamento := Emp2.Departamento;
              Emp3.MODIFY;
             END;
        UNTIL Emp.NEXT = 0;
        EXIT;
        */
        //Tercer paso

        HistoricoCabnomina.Reset;
        HistoricoCabnomina.SetRange("Tipo Nomina", HistoricoCabnomina."Tipo Nomina"::Normal);
        HistoricoCabnomina.SetRange("Tipo de nomina", '');
        HistoricoCabnomina.Find('-');
        repeat
            HistoricoCabnominaOut.TransferFields(HistoricoCabnomina);
            HistoricoCabnominaOut."Tipo de nomina" := 'MENSUAL';
            HistoricoCabnominaOut.Insert(true);
            HistoricoCabnomina.Delete;
        until HistoricoCabnomina.Next = 0;


        HistoricoLinnomina.Reset;
        HistoricoLinnomina.SetRange("Tipo Nómina", HistoricoLinnomina."Tipo Nómina"::Normal);
        HistoricoLinnomina.SetRange("Tipo de nomina", '');
        HistoricoLinnomina.Find('-');
        repeat
            HistoricoLinnominaOut.TransferFields(HistoricoLinnomina);
            HistoricoLinnominaOut."Tipo de nomina" := 'MENSUAL';
            HistoricoLinnominaOut.Insert(true);
            HistoricoLinnomina.Delete;
        until HistoricoLinnomina.Next = 0;

        CabAportesEmpresas.Reset;
        CabAportesEmpresas.SetRange("Tipo Nomina", CabAportesEmpresas."Tipo Nomina"::Normal);
        CabAportesEmpresas.SetRange("Tipo de nomina", '');
        CabAportesEmpresas.Find('-');
        repeat
            CabAportesEmpresasOut.TransferFields(CabAportesEmpresas);
            CabAportesEmpresasOut."Tipo de nomina" := 'MENSUAL';
            CabAportesEmpresasOut.Insert(true);
            CabAportesEmpresas.Delete;
        until CabAportesEmpresas.Next = 0;

        LinAportesEmpresas.Reset;
        LinAportesEmpresas.SetRange("Tipo Nomina", LinAportesEmpresas."Tipo Nomina"::Normal);
        LinAportesEmpresas.SetRange("Tipo de nomina", '');
        LinAportesEmpresas.Find('-');
        repeat
            LinAportesEmpresasOut.TransferFields(LinAportesEmpresas);
            LinAportesEmpresasOut."Tipo de nomina" := 'MENSUAL';
            LinAportesEmpresasOut.Insert;
            LinAportesEmpresas.Delete;
        until LinAportesEmpresas.Next = 0;

    end;
}

