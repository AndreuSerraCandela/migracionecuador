codeunit 76050 "NAS Nominas"
{

    trigger OnRun()
    begin
        ActivaEmpleado;
    end;

    local procedure ActivaEmpleado()
    var
        Emp: Record Employee;
    begin
        Emp.Reset;
        Emp.SetRange("Fecha reactivacion", Today);
        if Emp.FindSet then
            repeat
                Emp.Status := Emp.Status::Active;
                Emp."Inactive Date" := 0D;
                Emp."Fecha reactivacion" := 0D;
                Emp."Calcular Nomina" := true;
                Emp.Modify;
            until Emp.Next = 0;
    end;
}

