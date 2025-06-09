xmlport 60001 "_Importa Empleados"
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
                textelement(Dir2)
                {
                }
                textelement(Ciudad)
                {
                }
                textelement(cp)
                {
                }
                textelement(Provincia)
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
                textelement(CodVend)
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
                textelement(Tel3)
                {
                }
                textelement(Nac)
                {
                }
                textelement(Basura1)
                {
                }
                textelement(LugarNAc)
                {
                }
                textelement(Basura2)
                {
                }
                textelement(Basura3)
                {
                }
                textelement(Basura4)
                {
                }
                textelement(estc)
                {
                }
                textelement(NumHijos)
                {
                }
                textelement(Basura5)
                {
                }
                textelement(Profes)
                {
                }
                textelement(Basura6)
                {
                }
                textelement(TipoCta)
                {
                }
                textelement(ctaban)
                {
                }
                textelement(NSS2)
                {
                }
                textelement(ced2)
                {
                }
                textelement(tipoempl)
                {
                }
                textelement(Depto)
                {
                }
                textelement(Basura7)
                {
                }
                textelement(Basura8)
                {
                }
                textelement(Basura9)
                {
                }
                textelement(Basura10)
                {
                }
                textelement(Basura11)
                {
                }
                textelement(Basura12)
                {
                }
                textelement(Basura13)
                {
                }
                textelement(Basura14)
                {
                }
                textelement(Basura15)
                {
                }
                textelement(sueldo)
                {
                }
                textelement(Basura16)
                {
                }
                textelement(Basura17)
                {
                }
                textelement(Basura18)
                {
                }
                textelement(Basura19)
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
                Nomb2 := ConvertStr(Nomb2, '×', 'í');
                Nomb2 := ConvertStr(Nomb2, '±', 'ñ');
                Nomb2 := ConvertStr(Nomb2, '©', 'ñ');
                Ape1 := ConvertStr(Ape1, '×', 'í');
                Ape1 := ConvertStr(Ape1, '±', 'ñ');
                Ape1 := ConvertStr(Ape1, '©', 'ñ');
                Ape2 := ConvertStr(Ape2, '×', 'í');
                Ape2 := ConvertStr(Ape2, '±', 'ñ');
                Ape2 := ConvertStr(Ape2, '©', 'ñ');

                tipoempl := 'Fi';
                Clear(Empl);
                Empl."No." := CodEmpl;
                Empl."First Name" := Nomb;
                Empl."Middle Name" := Nomb2;
                Empl."Last Name" := Ape1;
                Empl."Second Last Name" := Ape2;

                Empl.Validate("First Name");
                //Empl."Working Center" := Sucursal;
                Empl.Address := CopyStr(Dir, 1, 60);
                Empl."Address 2" := CopyStr(Dir2, 1, 60);
                Empl.Validate(City, Ciudad);
                if cp <> '' then
                    Empl.Validate("Post Code", cp);
                Empl.County := Provincia;
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

                Evaluate(Empl."Employment Date", fecing);
                Empl.Validate("Employment Date");
                Empl."Company E-Mail" := mail2;
                if CodVend <> '' then
                    Empl."Salespers./Purch. Code" := CodVend;

                Empl.Company := 'SANTILLANA';
                if tipodoc = 'C.I.' then
                    Empl."Document Type" := 2
                else
                    if tipodoc = 'PASAPORTE' then
                        Empl."Document Type" := 1
                    else
                        Empl."Document Type" := 0;

                Empl.Validate("Document ID", ced);
                //IF (Nac = 'Guatemalteca') OR (Nac = 'Guatemalteco') THEN
                if CopyStr(Nac, 1, 5) = 'Boliv' then
                    Empl.Nacionalidad := 'BO'
                else
                    Empl.Nacionalidad := 'ES';

                //Empl."Permiso Trabajo MT"  := PermTrabMT;
                Empl."Lugar Nacimiento MT" := LugarNAc;
                //Empl."Etnia MT"            := EtniaMT;
                //Empl."Idioma MT"           := IdiomaMT;
                //Empl."Numero de Hijos MT"  := NumHijos;
                //Empl."Nivel Academico MT"  := NivelAcad;
                Empl.Profesion := Profes;
                //Empl."Puesto Segun MT"     := PuestoMT;
                if Empl.Insert then;

                if not Empl.Get(CodEmpl) then
                    exit;

                //Empl."Código Cliente" := Codcte;

                if CopyStr(estc, 1, 4) = 'Casa' then
                    Empl."Estado civil" := 1
                else
                    if CopyStr(estc, 1, 4) = 'Divo' then
                        Empl."Estado civil" := 4
                    else
                        Empl."Estado civil" := 0;

                DistCta."Cod. Banco" := 'B_BS_CTO';
                DistCta."No. empleado" := Empl."No.";
                DistCta."Numero Cuenta" := ctaban;
                if DistCta.Insert then;

                Empl."ID TSS" := NSS;


                Departamento.SetFilter(Descripcion, '%1', '*' + CopyStr(Depto, 1, 4) + '*');
                Departamento.FindFirst;
                Empl.Validate(Departamento, Departamento.Codigo);

                //Empl."Sub-Departamento" := subdepto;
                Empl."Lugar Nacimiento MT" := LugarNAc;
                Empl."Lugar nacimiento" := LugarNAc;
                Empl.Modify;


                if StrLen(cargo) = 1 then
                    cargo := '0' + cargo;


                if cargo <> '' then begin
                    //    CARGOS.SETRANGE(Descripción,UPPERCASE(cargo));
                    //    CARGOS.FINDFIRST;
                    Empl.Validate("Job Type Code", cargo);
                end;

                //Empl.VALIDATE("Job Type Code",cargo);

                Evaluate(Empl."Birth Date", fecnac);
                Empl.Validate("Birth Date");

                if StrPos(tipoempl, 'Fi') <> 0 then
                    Empl."Tipo Empleado" := 0
                else
                    Empl."Tipo Empleado" := 1;

                if not Empl.Insert then
                    Empl.Modify;

                Empl.Validate("Emplymt. Contract Code", '100');

                /*
                IF STRPOS(tipoempl,'Fi') <> 0 THEN
                   BEGIN
                //    contra.VALIDATE("No. empleado",CodEmpl);
                //    contra.VALIDATE("Cód. contrato",'100');
                    Empl.VALIDATE("Emplymt. Contract Code",'100');
                //    IF contra.INSERT THEN;
                   END
                ELSE
                   BEGIN
                //    contra.VALIDATE("No. empleado",CodEmpl);
                //    contra.VALIDATE("Cód. contrato",'101');
                    Empl.VALIDATE("Emplymt. Contract Code",'101');
                //    IF contra.INSERT THEN;
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

