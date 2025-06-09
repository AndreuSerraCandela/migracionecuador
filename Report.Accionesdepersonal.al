report 76251 "Acciones de personal"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Accionesdepersonal.rdlc';

    dataset
    {
        dataitem("Acciones de personal"; "Acciones de personal")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "Tipo de accion", "Cod. accion", "No. empleado", "Fecha accion", "Fecha efectividad";
            column(NombCompany; CompanyName)
            {
            }
            column(No_; "No.")
            {
            }
            column(Tipo_accion; "Tipo de accion")
            {
            }
            column(TAct; TAct)
            {
            }
            column(Cod_Accion; "Cod. accion")
            {
            }
            column(No_Empleado; "No. empleado")
            {
            }
            column(First_Name; "First Name")
            {
            }
            column(Middle_Name; "Middle Name")
            {
            }
            column(Last_Name; "Last Name")
            {
            }
            column(Second_L_Name; "Second Last Name")
            {
            }
            column(Nombre_; "Nombre completo")
            {
            }
            column(IDDocumento_; "ID Documento")
            {
            }
            column(Fecha_Nac; Format(vBirthDate, 0, '<Day,2>/<Month Text>/<Year4>'))
            {
            }
            column(Phone_No; VPhoneNo)
            {
            }
            column(E_Mail; vEMail)
            {
            }
            column(Gender_; Gender)
            {
            }
            column(Estado_Civil; vEstadocivil)
            {
            }
            column(Nacionalidad_; Nacionalidad)
            {
            }
            column(Emp_Direccion; vAddress)
            {
            }
            column(Emp_Direccion_2; vAddress2)
            {
            }
            column(Emp_Ciudad; vCity)
            {
            }
            column(Emp_FContrato; Format(Emp."Employment Date", 0, '<Day,2>/<Month Text>/<Year4>'))
            {
            }
            column(Emp_Lugar_Nac; vLugarnacimiento)
            {
            }
            column(Emp_Cell; vMobilePhoneNo)
            {
            }
            column(Emp_Nacionalidad; CountryRegion.Name)
            {
            }
            column(Edad_; Edad)
            {
            }
            column(Cost_Centre; Emp."Global Dimension 2 Code")
            {
            }
            column(Desc_Accion; "Descripcion accion")
            {
            }
            column(Fecha_accion; Format("Fecha accion", 0, '<Day,2>/<Month Text>/<Year4>'))
            {
            }
            column(Fecha_efectividad; Format("Fecha efectividad", 0, '<Day,2>/<Month Text>/<Year4>'))
            {
            }
            column(Comentario_1; Comentario)
            {
            }
            column(Cargo_actual; "Cargo actual")
            {
                IncludeCaption = true;
            }
            column(Desc_Cargo_actual; "Descripcion cargo actual")
            {
            }
            column(Cargo_Nuevo; "Nuevo cargo")
            {
            }
            column(Desc_Cargo_Nuevo; "Descripcion cargo nuevo")
            {
            }
            column(Sdo_Actual; "Sueldo actual")
            {
            }
            column(Sdo_Nuevo; "Sueldo Nuevo")
            {
            }
            column(Depto_Actual; "Departamento actual")
            {
            }
            column(Desc_Depto_Actual; "Nombre  depto. actual")
            {
            }
            column(Dpto_Nuevo; "Departamento nuevo")
            {
            }
            column(Desc_Depto_Nuevo; "Nombre depto. nuevo")
            {
            }
            column(Ubic_Actual; "Ubicacion actual")
            {
            }
            column(Ubic_Nueva; CentrosdeTrabajo.Nombre)
            {
            }
            column(ToEmpresa_; "Empresa nueva")
            {
            }
            column(Nro_Cta_actual; "Numero cuenta actual")
            {
            }
            column(Nro_Cta_nueva; BcoCta + ' - ' + "Numero cuenta nueva")
            {
            }
            column(Nro_Cta_tarjeta; BcoTarjeta + ' - ' + "Numero tarjeta")
            {
            }
            column(Fecha_Exp; "Fecha expiracion")
            {
            }
            column(Importe_Tarj; "Importe tarjeta")
            {
            }
            column(Nivel_actual; "Nivel actual")
            {
            }
            column(Nivel_Nuevo; "Nivel nuevo")
            {
            }
            column(Tipo_Contrato; EmploymentContract.Description)
            {
            }
            column(Preparado_por; "Preparado por")
            {
            }
            column(Revisado_por; "Revisado por")
            {
            }
            column(Autorizado_por; "Autorizado por")
            {
            }
            column(Tipo_Documento; "Document Type")
            {
            }
            column(Logo_; InfoEmpresa.Imagen)
            {
            }
            column(Nuevo_Cost_Centre; Cargo."Global Dimension 2 Code")
            {
            }
            column(Comentario_2; "Comentario 2")
            {
            }
            column(Marca_Cargo; MarcaCargo)
            {
            }
            column(Marca_Sueldo_Mensual; MarcaSueldoMensual)
            {
            }
            column(Marca_Numero_Cuenta; MarcaNumeroCuenta)
            {
            }
            column(Marca_Depto; MarcaDepto)
            {
            }
            column(tipoContrato; tipoContrato)
            {
            }
            column(FechaIngreso; Format(FechaIngreso, 0, '<Day,2> <Month Text> <Year4>'))
            {
            }
            column(Hora; Time)
            {
            }
            column(Pais_; CountryRegion.Name)
            {
            }
            column(Hasta_; Format("Fecha final", 0, '<Day,2> <Month Text> <Year4>'))
            {
            }
            column(Supervisor; "Nombre Supervisor")
            {
            }

            trigger OnAfterGetRecord()
            begin
                InfoEmpresa.FindFirst;
                InfoEmpresa.CalcFields(Imagen);

                if not Cargo.Get("Departamento nuevo", "Nuevo cargo") then
                    Cargo.Init;

                if not CountryRegion.Get(Emp."Country/Region Code") then
                    CountryRegion.Init;

                if "Tipo de accion" = "Tipo de accion"::Salida then
                    TipoSalida := "Cod. accion";

                MarcaCargo := "Cargo actual" <> "Nuevo cargo";
                //CentroCosto := "Acciones de personal".CE
                MarcaSueldoMensual := "Sueldo actual" <> "Sueldo Nuevo";
                MarcaNumeroCuenta := "Numero cuenta actual" <> "Numero cuenta nueva";
                MarcaDepto := "Departamento actual" <> "Departamento nuevo";
                Nacionalidad := "Country/Region Code";

                if "Tipo de accion" = "Acciones de personal"."Tipo de accion"::Salida then begin
                    TAct := 3;
                end;

                if "Tipo de accion" = "Acciones de personal"."Tipo de accion"::Cambio then begin
                    TAct := 2;
                end;

                if "Tipo de accion" = "Acciones de personal"."Tipo de accion"::Ingreso then begin
                    TAct := 1;

                end;

                if not Emp.Get("No. empleado") then begin
                    Emp.Init;
                    rCandidates.Reset;
                    if rCandidates.Get("Cod. elegible") then begin
                        VPhoneNo := rCandidates."Phone No.";
                        vEMail := rCandidates."E-Mail";
                        vBirthDate := rCandidates."Birth Date";
                        vGender := rCandidates.Gender;
                        vEstadocivil := rCandidates."Estado civil";
                        vAddress := rCandidates.Address;
                        vAddress2 := rCandidates."Address 2";
                        vCity := rCandidates.City;
                        vLugarnacimiento := rCandidates."Lugar nacimiento";
                        vMobilePhoneNo := rCandidates."Mobile Phone No.";
                        vGlobalDimension2Code := rCandidates."Global Dimension 2 Filter";
                        /*if rCandidates."Birth Date" <> 0D then
                            Edad := FuncionesNom.CalculoEntreFechaDotNet('YYYY', CreateDateTime(rCandidates."Birth Date", Time), CurrentDateTime);*/
                    end;

                end else begin
                    VPhoneNo := Emp."Phone No.";
                    vAddress := Emp.Address;
                    vAddress2 := Emp."Address 2";
                    vCity := Emp.City;
                    vLugarnacimiento := Emp."Lugar nacimiento";
                    vMobilePhoneNo := Emp."Mobile Phone No.";
                    vGlobalDimension2Code := Emp."Global Dimension 2 Filter";
                    vBirthDate := Emp."Birth Date";
                    vGender := Emp.Gender;
                    vEstadocivil := Emp."Estado civil";
                    vEMail := Emp."Company E-Mail";

                    /*if Emp."Birth Date" <> 0D then
                        Edad := FuncionesNom.CalculoEntreFechaDotNet('YYYY', CreateDateTime(Emp."Birth Date", Time), CurrentDateTime);*/

                end;

                Contrato.Reset;
                Contrato.SetRange("No. empleado", Emp."No.");
                if not Contrato.FindLast then
                    Contrato.Init;

                if not EmploymentContract.Get("Tipo de contrato") then
                    EmploymentContract.Init;
                CentrosdeTrabajo.Reset;
                CentrosdeTrabajo.SetRange("Centro de trabajo", "Ubicacion nueva");
                if CentrosdeTrabajo.FindFirst then;

                if "Tipo de accion" = "Tipo de accion"::Ingreso then
                    FechaIngreso := "Fecha efectividad"
                else
                    FechaIngreso := Contrato."Fecha inicio";


                if BancosACH.Get("Cod. Banco") then
                    BcoCta := BancosACH.Descripcion;

                //IF BancosACH.GET("Banco tarjeta") THEN
                //  BcoTarjeta := BancosACH.Descripcion;{
                /*
                User.GET("Preparado por");
                "Preparado por":= User."Full Name";
                */

                Seleccionbeneficios.Reset;
                Seleccionbeneficios.SetRange("No. documento", "No.");
                //Seleccionbeneficios.SETRANGE("Cod. Empleado","No. empleado");
                Seleccionbeneficios.SetRange(Seleccionar, true);
                if Seleccionbeneficios.FindSet then
                    repeat
                        if Seleccionbeneficios."Tipo Beneficio" = Seleccionbeneficios."Tipo Beneficio"::Ingresos then begin
                            if Comentario = '' then
                                Comentario += Seleccionbeneficios.Descripcion + ', ' + Format(Seleccionbeneficios.Importe, 0, '<Integer thousand><Decimals,3>')
                            else
                                if StrLen(Comentario + ', ' + Seleccionbeneficios.Descripcion + ': ' + Format(Seleccionbeneficios.Importe, 0, '<Integer thousand><Decimals,3>')) < MaxStrLen(Comentario) then
                                    Comentario += ', ' + Seleccionbeneficios.Descripcion + ', ' + Format(Seleccionbeneficios.Importe, 0, '<Integer thousand><Decimals,3>')
                                else
                                    if StrLen("Comentario 2" + ', ' + Seleccionbeneficios.Descripcion + ', ' + Format(Seleccionbeneficios.Importe, 0, '<Integer thousand><Decimals,3>')) < MaxStrLen("Comentario 2") then
                                        "Comentario 2" += ', ' + Seleccionbeneficios.Descripcion + ': ' + Format(Seleccionbeneficios.Importe, 0, '<Integer thousand><Decimals,3>')
                        end
                        else begin
                            if Comentario = '' then
                                Comentario += Seleccionbeneficios.Descripcion
                            else
                                if StrLen(Comentario + ', ' + Seleccionbeneficios.Descripcion) < MaxStrLen(Comentario) then
                                    Comentario += ', ' + Seleccionbeneficios.Descripcion
                                else
                                    if StrLen("Comentario 2" + ', ' + Seleccionbeneficios.Descripcion) < MaxStrLen("Comentario 2") then
                                        "Comentario 2" += ', ' + Seleccionbeneficios.Descripcion;
                        end
                    until Seleccionbeneficios.Next = 0;

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

    labels
    {
    }

    var
        InfoEmpresa: Record "Empresas Cotizacion";
        Contrato: Record Contratos;
        CountryRegion: Record "Country/Region";
        Cargo: Record "Puestos laborales";
        BancosACH: Record "Bancos ACH Nomina";
        User: Record User;
        EmploymentContract: Record "Employment Contract";
        CentrosdeTrabajo: Record "Centros de Trabajo";
        Seleccionbeneficios: Record "Seleccion beneficios";
        //FuncionesNom: Codeunit "Funciones Nomina";
        MarcaCargo: Boolean;
        MarcaSueldoMensual: Boolean;
        MarcaNumeroCuenta: Boolean;
        MarcaDepto: Boolean;
        Nacionalidad: Text[60];
        Edad: Integer;
        TipoSalida: Code[20];
        BcoCta: Code[20];
        BcoTarjeta: Code[20];
        FechaIngreso: Date;
        TAct: Integer;
        NumTarjeta: Code[20];
        NumTarjetaNueva: Code[20];
        Rcontratos: Record "Employment Contract";
        tipoContrato: Code[20];
        Hasta: Date;
        VPhoneNo: Text[30];
        vEMail: Text[80];
        vBirthDate: Date;
        //vGender: Option " ",Female,Male;
        vGender: Enum "Employee Gender";
        vEstadocivil: Option "Soltero/a","Casado/a","Viudo/a","Separado/a","Divorciado/a","Unión libre";
        vAddress: Text[60];
        vAddress2: Text[50];
        vCity: Text[30];
        vLugarnacimiento: Text[30];
        vMobilePhoneNo: Text[30];
        vGlobalDimension2Code: Code[20];
        rCandidates: Record Elegibles;
        Supervisor: Text[100];
        EmpSuper: Record Employee;
        Emp: Record Employee;


    procedure AgregarSupervisor(VSupervisor: Code[20])
    begin
        if EmpSuper.Get(VSupervisor) then
            Supervisor := EmpSuper."First Name" + ' ' + EmpSuper."Last Name";
    end;
}

