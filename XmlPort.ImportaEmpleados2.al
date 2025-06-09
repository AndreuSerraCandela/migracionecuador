xmlport 58011 "Importa Empleados 2"
{
    Direction = Import;
    Format = VariableText;

    schema
    {
        textelement(ImportaEmpleados)
        {
            tableelement(Integer; Integer)
            {
                XmlName = 'Empleados';
                textelement(CodEmpl)
                {
                }
                textelement(Nomb)
                {
                }
                textelement(Nomb2)
                {
                }
                textelement(Ape1)
                {
                }
                textelement(Ape2)
                {
                }
                textelement(Dir)
                {
                }
                textelement(Ciudad)
                {
                }
                textelement(cp)
                {
                }
                textelement(Tel1)
                {
                }
                textelement(Cel)
                {
                }
                textelement(mail)
                {
                }
                textelement(fecnac)
                {
                }
                textelement(NSS)
                {
                }
                textelement(sex)
                {
                }
                textelement(fecing)
                {
                }
                textelement(mail2)
                {
                }
                textelement(tipodoc)
                {
                }
                textelement(ced)
                {
                }
                textelement(cargo)
                {
                }
                textelement(Nac)
                {
                }
                textelement(LugarNac)
                {
                }
                textelement(estc)
                {
                }
            }

            trigger OnAfterAssignVariable()
            begin

                found := 0;
                //txtApellidos := CONVERTSTR(Ape,' ',',');
                //IF Nomb2 <> 'Rolando' THEN
                //   EXIT;
                //IF Nomb2 = 'Rolando' THEN
                //   MESSAGE('aa%1 bb%2',Ape1,Ape2);

                Nomb := ConvertStr(Nomb, '×', 'í');
                Nomb := ConvertStr(Nomb, '±', 'ñ');
                Nomb := ConvertStr(Nomb, '©', 'ñ');
                Nomb := ConvertStr(Nomb, 'Ý', 'ó');
                Nomb2 := ConvertStr(Nomb2, '×', 'í');
                Nomb2 := ConvertStr(Nomb2, '±', 'ñ');
                Nomb2 := ConvertStr(Nomb2, '©', 'ñ');
                Nomb2 := ConvertStr(Nomb2, 'Ý', 'ó');
                Ape1 := ConvertStr(Ape1, '×', 'í');
                Ape1 := ConvertStr(Ape1, '±', 'ñ');
                Ape1 := ConvertStr(Ape1, '©', 'ñ');
                Ape1 := ConvertStr(Ape1, 'Ý', 'ó');
                Ape2 := ConvertStr(Ape2, '×', 'í');
                Ape2 := ConvertStr(Ape2, '±', 'ñ');
                Ape2 := ConvertStr(Ape2, '©', 'ñ');
                Ape2 := ConvertStr(Ape2, 'Ý', 'ó');

                Clear(Empl);
                Empl."No." := CodEmpl;
                Empl."First Name" := Nomb;
                Empl."Middle Name" := Nomb2;
                Empl."Last Name" := Ape1;
                Empl."Second Last Name" := Ape2;

                Empl.Validate("First Name");
                //Empl."Working Center" := Sucursal;
                Empl.Address := Dir;
                Empl.Validate(City, Ciudad);
                if cp <> '' then
                    Empl.Validate("Post Code", cp);
                Empl."Phone No." := Tel1;
                Empl."Mobile Phone No." := Cel;
                Empl."E-Mail" := mail;
                if fecnac <> '' then begin
                    Evaluate(Empl."Birth Date", fecnac);
                    Empl.Validate("Birth Date");
                end;

                if UpperCase(sex) = 'M' then
                    Empl.Gender := Empl.Gender::Male
                else
                    Empl.Gender := Empl.Gender::Female;

                if fecing <> '' then
                    Evaluate(Empl."Employment Date", fecing);

                Empl."Company E-Mail" := mail2;

                Empl.Company := 'SANTILLANA';
                if tipodoc = 'DPI' then
                    Empl."Document Type" := 2
                else
                    if tipodoc = 'PASAPORTE' then
                        Empl."Document Type" := 1
                    else
                        Empl."Document Type" := 0;

                Empl.Validate("Document ID", ced);
                //IF (Nac = 'Guatemalteca') OR (Nac = 'Guatemalteco') THEN
                if CopyStr(Nac, 1, 5) = 'Panam' then
                    Empl.Nacionalidad := 'PA'
                else
                    Empl.Nacionalidad := 'ES';

                Empl."Lugar Nacimiento MT" := LugarNac;
                if Empl.Insert then;

                if not Empl.Get(CodEmpl) then
                    exit;


                if (CopyStr(estc, 1, 4) = 'Casa') or (CopyStr(estc, 1, 4) = 'casa') then
                    Empl."Estado civil" := 1
                else
                    if (CopyStr(estc, 1, 4) = 'Divo') or (CopyStr(estc, 1, 4) = 'divo') then
                        Empl."Estado civil" := 4
                    else
                        if (CopyStr(estc, 1, 4) = 'Viud') or (CopyStr(estc, 1, 4) = 'viud') then
                            Empl."Estado civil" := 2
                        else
                            Empl."Estado civil" := 0;

                DistCta."Cod. Banco" := 'BCR_A';
                DistCta."No. empleado" := Empl."No.";
                if DistCta.Insert then;

                Empl."ID TSS" := NSS;


                Departamento.FindFirst;
                Empl.Validate(Departamento, Departamento.Codigo);

                //Empl."Sub-Departamento" := subdepto;
                Empl."Lugar Nacimiento MT" := LugarNac;
                Empl."Lugar nacimiento" := LugarNac;
                Empl.Modify;

                if cargo <> '' then
                    Empl.Validate("Job Type Code", cargo);

                //Empl.VALIDATE("Job Type Code",cargo);
                if fecnac <> '' then
                    Evaluate(Empl."Birth Date", fecnac);

                if not Empl.Insert then
                    Empl.Modify;

                Empl.Validate("Emplymt. Contract Code", '100');

                /*
                IF tipoempl ='100' THEN
                   BEGIN
                    contra.INIT;
                    contra.VALIDATE("No. empleado",CodEmpl);
                    contra.VALIDATE("Cód. contrato",'100');
                    Empl.VALIDATE("Emplymt. Contract Code",'100');
                    IF contra.INSERT THEN;
                   END
                ELSE
                   BEGIN
                    contra.VALIDATE("No. empleado",CodEmpl);
                    contra.VALIDATE("Cód. contrato",'101');
                    Empl.VALIDATE("Emplymt. Contract Code",'101');
                    IF contra.INSERT THEN;
                   END;
                */

                //Empl.VALIDATE("Job Type Code",CARGOS.Código);

                Empl.Modify;
                /*
                DimVal.SETRANGE("Dimension Code",'EMPLEADOS');
                DimVal.SETRANGE(Code,DimEmp);
                IF DimVal.FINDFIRST THEN
                   BEGIN
                    IF DimVal.Name = '' THEN
                       BEGIN
                        DimVal.Name := Empl."Full Name";
                        DimVal.MODIFY;
                       END;
                   END
                ELSE
                  BEGIN
                   CLEAR(DimVal);
                   DimVal."Dimension Code" := 'EMPLEADOS';
                   DimVal.Code := DimEmp;
                   DimVal.Name := Empl."Full Name";
                   DimVal.INSERT;
                  END;
                
                CLEAR(DefDim);
                DefDim."Table ID" := 5200;
                DefDim."No." := Empl."No.";
                DefDim.VALIDATE("Dimension Code",'DEPARTAMENTO');
                DefDim.VALIDATE("Dimension Value Code",DimDepto);
                IF DefDim.INSERT(TRUE) THEN;
                
                CLEAR(DefDim);
                DefDim."Table ID" := 5200;
                DefDim."No." := Empl."No.";
                DefDim.VALIDATE("Dimension Code",'LINEA_NEGOCIO');
                DefDim.VALIDATE("Dimension Value Code",DimLin);
                IF DefDim.INSERT(TRUE) THEN;
                
                CLEAR(DefDim);
                DefDim."Table ID" := 5200;
                DefDim."No." := Empl."No.";
                DefDim.VALIDATE("Dimension Code",'EMPLEADOS');
                DefDim.VALIDATE("Dimension Value Code",DimEmp);
                IF DefDim.INSERT(TRUE) THEN;
                */

                Commit;

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

    var
        Empl: Record Employee;
        esqsal: Record "Perfil Salarial";
        contra: Record Contratos;
        CARGOS: Record "Puestos laborales";
        DistCta: Record "Distrib. Ingreso Pagos Elect.";
        DefDim: Record "Default Dimension";
        DimVal: Record "Dimension Value";
        Departamento: Record Departamentos;
        SubDepartamento: Record "Sub-Departamentos";
        Sucursal: Code[10];
        found: Integer;
}

