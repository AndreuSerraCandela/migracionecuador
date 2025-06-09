#pragma implicitwith disable
page 76061 "Ficha Acciones de personal"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Acciones de personal";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Tipo de accion"; rec."Tipo de accion")
                {

                    trigger OnValidate()
                    begin
                        EnableFields;
                    end;
                }
                field("Cod. accion"; rec."Cod. accion")
                {

                    trigger OnValidate()
                    begin
                        EnableFields;
                    end;
                }
                field("No. empleado"; rec."No. empleado")
                {
                }
                field("Proximo no. empleado"; rec."Proximo no. empleado")
                {
                    Visible = ProxNoEmpVisible;
                }
                field("First Name"; rec."First Name")
                {
                }
                field("Middle Name"; rec."Middle Name")
                {
                }
                field("Last Name"; rec."Last Name")
                {
                }
                field("Second Last Name"; rec."Second Last Name")
                {
                }
                field("Nombre completo"; rec."Nombre completo")
                {
                    Editable = false;
                }
                field("Document Type"; rec."Document Type")
                {
                }
                field("ID Documento"; rec."ID Documento")
                {
                }
                field("Country/Region Code"; rec."Country/Region Code")
                {
                }
                field("Descripcion accion"; rec."Descripcion accion")
                {
                }
                field("Fecha accion"; rec."Fecha accion")
                {
                }
                field("Fecha efectividad"; rec."Fecha efectividad")
                {
                }
                field("Cause of Inactivity Code"; rec."Cause of Inactivity Code")
                {
                    Editable = EditaInactividad;
                }
                field("Fecha final"; rec."Fecha final")
                {
                    Editable = EditaInactividad;
                }
                grid(Control1000000071)
                {
                    GridLayout = Columns;
                    ShowCaption = false;
                    group(Control1000000070)
                    {
                        //The GridLayout property is only supported on controls of type Grid
                        //GridLayout = Rows;
                        ShowCaption = false;
                        field(Comentario; rec.Comentario)
                        {
                            MultiLine = true;
                        }
                        field("Comentario 2"; rec."Comentario 2")
                        {
                            MultiLine = true;
                        }
                    }
                }
            }
            group(Changes)
            {
                Caption = 'Changes';
                field("Departamento actual"; rec."Departamento actual")
                {
                }
                field("Nombre  depto. actual"; rec."Nombre  depto. actual")
                {
                }
                field("Departamento nuevo"; rec."Departamento nuevo")
                {
                }
                field("Nombre depto. nuevo"; rec."Nombre depto. nuevo")
                {
                }
                field("Cargo actual"; rec."Cargo actual")
                {
                }
                field("Descripcion cargo actual"; rec."Descripcion cargo actual")
                {
                }
                field("Nuevo cargo"; rec."Nuevo cargo")
                {
                }
                field("Descripcion cargo nuevo"; rec."Descripcion cargo nuevo")
                {
                }
                field("Cod. Supervisor"; rec."Cod. Supervisor")
                {
                }
                field("Nombre Supervisor"; rec."Nombre Supervisor")
                {
                    Editable = false;
                }
                field("Sueldo actual"; rec."Sueldo actual")
                {
                }
                field("Sueldo Nuevo"; rec."Sueldo Nuevo")
                {
                    Editable = EditaSalario;
                }
                field("Ubicacion actual"; rec."Ubicacion actual")
                {
                }
                field("Ubicacion nueva"; rec."Ubicacion nueva")
                {
                }
                field("Empresa nueva"; rec."Empresa nueva")
                {
                    Editable = editaempresa;
                }
                field("Numero cuenta actual"; rec."Numero cuenta actual")
                {
                }
                field("Nivel actual"; rec."Nivel actual")
                {
                }
                field("Nivel nuevo"; rec."Nivel nuevo")
                {
                }
                field("Cod. Banco"; rec."Cod. Banco")
                {
                }
                field("Numero cuenta nueva"; rec."Numero cuenta nueva")
                {
                }
                field("Banco tarjeta"; rec."Banco tarjeta")
                {
                }
                field("Numero tarjeta"; rec."Numero tarjeta")
                {
                }
                field("Fecha expiracion"; rec."Fecha expiracion")
                {
                }
                field("Importe tarjeta"; rec."Importe tarjeta")
                {
                }
                field("Tipo de contrato"; rec."Tipo de contrato")
                {

                    trigger OnValidate()
                    begin
                        TipoContrato := false;
                        if EmploymentContract.Get(Rec."Tipo de contrato") then
                            TipoContrato := not EmploymentContract.Undefined;
                    end;
                }
                field("Fecha de inicio"; rec."Fecha de inicio")
                {
                    Editable = TipoContrato;
                }
                field(FF; rec."Fecha final")
                {
                    Editable = TipoContrato;
                }
                field("Duracion contrato"; rec."Duracion contrato")
                {
                    Editable = TipoContrato;
                }
            }
            group(Benefits)
            {
                Caption = 'Benefits';
                part(Control1000000060; "Seleccion beneficios")
                {
                    SubPageLink = "No. documento" = FIELD("No.");
                    SubPageView = SORTING("No. documento", "Cod. Empleado", "Tipo Beneficio", Codigo);
                }
            }
            group(Cooperative)
            {
                Caption = 'Cooperative';
                Visible = CoopVisible;
                field("Tipo de miembro"; rec."Tipo de miembro")
                {
                }
                field("Fecha inscripcion"; rec."Fecha inscripcion")
                {
                }
                field("Tipo de aporte"; rec."Tipo de aporte")
                {
                }
                field(Importe; rec.Importe)
                {
                }
                field("1ra Quincena"; rec."1ra Quincena")
                {
                }
                field("2da Quincena"; rec."2da Quincena")
                {
                }
            }
            group(Control1000000046)
            {
                Caption = 'Benefits';
                field(Preaviso; rec.Preaviso)
                {
                }
                field(Cesantia; rec.Cesantia)
                {
                }
                field(Regalia; rec.Regalia)
                {
                }
            }
            group(Control1000000033)
            {
                Caption = 'Authorizations';
                //The GridLayout property is only supported on controls of type Grid
                //GridLayout = Columns;
                field("Preparado por"; rec."Preparado por")
                {
                }
                field("Revisado por"; rec."Revisado por")
                {
                }
                field("Autorizado por"; rec."Autorizado por")
                {
                }
            }
        }
        area(factboxes)
        {
            part(Control1000000062; "DSNOM Qualification FactBox")
            {
                ApplicationArea = BasicHR;
                SubPageLink = "Employee No." = FIELD("No. empleado");
            }
            part("76192"; "DSNOM Tools FactBox")
            {
                ApplicationArea = BasicHR;
                SubPageLink = "Employee No." = FIELD("No. empleado");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Authorizations)
            {
                Caption = 'Authorizations';
                action(Revisado)
                {
                    Caption = 'Reviewed';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        Usuariosautorizan.Get(UserId);
                        if not Usuariosautorizan."Revisado por" then
                            Error(StrSubstNo(Err001, UserId));

                        //Para cuando el numerador de empleados es comun a las empresas
                        ConfNominas.Get();
                        if (ConfNominas."Habilitar numeradores globales") and (Rec."Tipo de accion" = Rec."Tipo de accion"::Ingreso) then begin
                            Numeradorescomunes.FindFirst;
                            Numeradorescomunes.TestField("No. serie empleados");
                            Rec."No. empleado" := IncStr(Numeradorescomunes."No. serie empleados");
                            Numeradorescomunes."No. serie empleados" := Rec."No. empleado";
                            Numeradorescomunes.Modify;
                        end
                        else begin
                            if Rec."Tipo de accion" = Rec."Tipo de accion"::Ingreso then begin
                                Rec."Cod. elegible" := Rec."No. empleado";
                                HumanResSetup.Get;
                                HumanResSetup.TestField("Employee Nos.");
                                //NoSeriesMgt.InitSeries(HumanResSetup."Employee Nos.", xRec."No. serie", 0D, Rec."No. empleado", Rec."No. serie");
                                Rec."No. serie" := HumanResSetup."Employee Nos.";
                                if NoSeriesMgt.AreRelated(HumanResSetup."Employee Nos.", xRec."No. Serie") then
                                    Rec."No. Serie" := xRec."No. Serie";
                                Rec."No. empleado" := NoSeriesMgt.GetNextNo(Rec."No. Serie");
                            end;
                        end;

                        Rec."Revisado por" := UserId;
                        Rec.Modify(true)
                    end;
                }
                action(Autorizado)
                {
                    Caption = 'Authorize';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        Usuariosautorizan.Get(UserId);
                        if not Usuariosautorizan."Autorizado por" then
                            Error(StrSubstNo(Err001, UserId));

                        Rec."Autorizado por" := UserId;
                        Rec.Modify;

                        Registrar;
                    end;
                }
                action(Print)
                {
                    Caption = 'Print';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        AP: Record "Acciones de personal";
                    begin
                        Commit;
                        Rec.TestField("Revisado por");
                        CurrPage.SetSelectionFilter(AP);
                        REPORT.Run(REPORT::"Acciones de personal", true, true, AP);
                    end;
                }
                action(archivar)
                {
                    Caption = 'Void';
                    Image = VoidRegister;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ArchAccionesdepersonal: Record "Arch. Acciones de personal";
                    begin
                        if Confirm(StrSubstNo(Msg001, Rec.TableCaption), false) then begin
                            ArchAccionesdepersonal.Init;
                            ArchAccionesdepersonal.TransferFields(Rec);
                            if ArchAccionesdepersonal.Insert then
                                Rec.Delete();
                            Message(Msg003);
                        end;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        TipoContrato := false;
        if EmploymentContract.Get(Rec."Tipo de contrato") then
            TipoContrato := not EmploymentContract.Undefined;

        InsertaSelBeneficios;
    end;

    trigger OnOpenPage()
    begin
        ConfNominas.Get();
        EnableFields;
        CoopVisible := ConfNominas."Mod. cooperativa activo";
    end;

    var
        ConfNominas: Record "Configuracion nominas";
        HumanResSetup: Record "Human Resources Setup";
        Emp: Record Employee;
        Emp2: Record Employee;
        Usuariosautorizan: Record "Seguridad Usuarios RH";
        EmpCotiza: Record "Empresas Cotizacion";
        Cuentas: Record "Distrib. Ingreso Pagos Elect.";
        PerfSal: Record "Perfil Salarial";
        PerfSal2: Record "Perfil Salarial";
        PerfilSalarioxCargo: Record "Perfil Salario x Cargo";
        Msg001: Label 'The action has been registered successfully';
        Msg002: Label 'Are you sure you want to void the %1?';
        Msg003: Label 'Action sucessfuly voided';
        Msg004: Label 'The %1 %2 does not have marked %3 and/or %4. Do you wish to continue?';
        Err001: Label 'Userid %1 does not have the permission to approbe';
        Err002: Label 'The salary profile for the %1 position must be configured before proceeding';
        HistAccionesdepersonal: Record "Hist. Acciones de personal";
        Cont: Record Contratos;
        Cargos: Record "Puestos laborales";
        Tiposdeaccionespersonal: Record "Tipos de acciones personal";
        EmploymentContract: Record "Employment Contract";
        Candidato: Record Elegibles;
        HistSalario: Record "Acumulado Salarios";
        HistSalario2: Record "Acumulado Salarios";
        Numeradorescomunes: Record "Numeradores globales";
        Seleccionbeneficios: Record "Seleccion beneficios";
        Beneficiosempleados: Record "Beneficios empleados";
        Miembroscooperativa: Record "Miembros cooperativa";

        //NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeriesMgt: Codeunit "No. Series";
        EditaSalario: Boolean;
        EditaAutorizado: Boolean;
        EditaEmpresa: Boolean;
        TipoContrato: Boolean;
        EditaInactividad: Boolean;
        CoopVisible: Boolean;
        Err003: Label 'Action canceled by user';
        ProxNoEmpVisible: Boolean;

    local procedure EnableFields()
    var
        Tiposdeaccionespersonal: Record "Tipos de acciones personal";
    begin
        if Rec."Tipo de accion" = 0 then
            exit;

        EditaSalario := false;
        EditaEmpresa := false;

        Tiposdeaccionespersonal.Reset;
        Tiposdeaccionespersonal.SetRange("Tipo de accion", Rec."Tipo de accion");
        Tiposdeaccionespersonal.SetRange(Codigo, Rec."Cod. accion");
        if not Tiposdeaccionespersonal.FindFirst then
            Tiposdeaccionespersonal.Init;

        EditaSalario := Tiposdeaccionespersonal."Editar salario";
        EditaEmpresa := Tiposdeaccionespersonal."Transferir entre empresas";
        EditaInactividad := Tiposdeaccionespersonal.Suspension;
        if Tiposdeaccionespersonal.Suspension then
            TipoContrato := true;

        ProxNoEmpVisible := false;
        if Rec."Tipo de accion" = Rec."Tipo de accion"::Ingreso then
            ProxNoEmpVisible := true;
    end;

    local procedure Registrar()
    begin
        //Poner validaciones
        EmpCotiza.FindFirst;
        Tiposdeaccionespersonal.Get(Rec."Tipo de accion", Rec."Cod. accion");

        Rec.TestField("Fecha efectividad");
        if Rec."Tipo de accion" = Rec."Tipo de accion"::Salida then
            Salida()
        else
            if Rec."Tipo de accion" = Rec."Tipo de accion"::Cambio then begin
                if Tiposdeaccionespersonal."Transferir entre empresas" then
                    Transferencia()
                else
                    Cambio()
            end
            else
                if Rec."Tipo de accion" = Rec."Tipo de accion"::Ingreso then
                    Entrada();
    end;

    local procedure Entrada()
    begin
        Rec.TestField("Fecha efectividad");
        ConfNominas.TestField("Concepto Sal. Base");
        Clear(Emp);

        Emp.Validate("Employment Date", Rec."Fecha efectividad");
        Emp.Validate(Company, EmpCotiza."Empresa cotizacion");
        Emp.Validate(Departamento, Rec."Departamento nuevo");
        Emp."Job Type Code" := Rec."Nuevo cargo";

        Emp."Emplymt. Contract Code" := Rec."Tipo de contrato";
        Emp.Insert(true);

        Candidato.Get(Rec."Cod. elegible");
        Rec.TestField("Departamento nuevo");
        Rec.TestField("Nuevo cargo");
        Rec.TestField("Sueldo Nuevo");
        Rec.TestField("Tipo de contrato");
        PerfilSalarioxCargo.Reset;
        PerfilSalarioxCargo.SetRange("Puesto de Trabajo", Rec."Nuevo cargo");
        if not PerfilSalarioxCargo.FindFirst then
            Error(StrSubstNo(Err002, Rec."Nuevo cargo"));

        Emp.Validate("First Name", Rec."First Name");
        Emp.Validate("Middle Name", Rec."Middle Name");
        Emp.Validate("Last Name", Rec."Last Name");
        Emp.Validate("Second Last Name", Rec."Second Last Name");
        Emp.Address := Candidato.Address;
        Emp."Address 2" := Candidato."Address 2";
        Emp.Validate(City, Candidato.City);
        Emp.Validate("Post Code", Candidato."Post Code");
        Emp.Validate(County, Candidato.County);
        Emp."Phone No." := Candidato."Phone No.";
        Emp."Mobile Phone No." := Candidato."Mobile Phone No.";
        Emp."E-Mail" := Candidato."E-Mail";
        Emp.Validate("Birth Date", Candidato."Birth Date");
        Emp.Gender := Candidato.Gender;
        Emp."Document Type" := Rec."Document Type";
        Emp.Validate("Document ID", Rec."ID Documento");
        Emp.Validate("Lugar nacimiento", Candidato."Lugar nacimiento");
        Emp.Validate("Estado civil", Candidato."Estado civil");
        Emp.Validate(Nacionalidad, Candidato.Nacionalidad);
        Emp.Validate(Departamento, Rec."Departamento nuevo");
        Emp.Validate("Job Type Code", Rec."Nuevo cargo");
        Emp.Validate("Employee Level", Rec."Nivel nuevo");
        Emp.Validate("Emplymt. Contract Code", Rec."Tipo de contrato");
        Emp.Validate(Departamento, Rec."Departamento nuevo");
        Cargos.Get(Emp.Departamento, Rec."Nuevo cargo");
        if Cargos."Global Dimension 1 Code" <> '' then
            Emp.Validate("Global Dimension 1 Code", Cargos."Global Dimension 1 Code");
        if Cargos."Global Dimension 2 Code" <> '' then
            Emp.Validate("Global Dimension 2 Code", Cargos."Global Dimension 2 Code");

        if Rec."Ubicacion nueva" <> '' then
            Emp.Validate("Working Center", Rec."Ubicacion nueva");

        Emp.Modify;

        PerfSal.Reset;
        PerfSal.SetRange("No. empleado", Emp."No.");
        PerfSal.SetRange("Concepto salarial", ConfNominas."Concepto Sal. Base");
        PerfSal.FindFirst;
        PerfSal.Validate(Cantidad, 1);
        PerfSal.Validate(Importe, Rec."Sueldo Nuevo");
        PerfSal.Modify;

        if Rec."Numero cuenta nueva" <> '' then begin
            Rec.TestField("Cod. Banco");
            Commit;
            Cuentas.Init;
            Cuentas.Validate("No. empleado", Emp."No.");
            Cuentas.Validate("Cod. Banco", Rec."Cod. Banco");
            Cuentas.Validate("Numero Cuenta", Rec."Numero cuenta nueva");
            if not Cuentas.Insert then
                Cuentas.Modify;
        end;

        if Rec."Numero tarjeta" <> '' then begin
            Rec.TestField("Banco tarjeta");
            Rec.TestField("Fecha expiracion");
            Rec.TestField("Importe tarjeta");
            Cuentas.Init;
            Cuentas.Validate("No. empleado", Emp."No.");
            Cuentas.Validate("Cod. Banco", Rec."Banco tarjeta");
            Cuentas.Validate("Nro. tarjeta", Rec."Numero tarjeta");
            Cuentas."Fecha vencimiento" := Rec."Fecha expiracion";
            Cuentas.Importe := Rec."Importe tarjeta";
            if not Cuentas.Insert then
                Cuentas.Modify;
        end;

        if Rec."Cod. Supervisor" <> '' then
            Emp.Validate("Cod. Supervisor", Rec."Cod. Supervisor");

        InsertaSelBeneficios;

        HistAccionesdepersonal.TransferFields(Rec);
        HistAccionesdepersonal."No. empleado" := Emp."No.";
        HistAccionesdepersonal.Insert(true);
        Rec.Delete;

        if ConfNominas."Mod. cooperativa activo" then begin
            Miembroscooperativa.Init;
            Miembroscooperativa.Validate("Employee No.", Emp."No.");
            Miembroscooperativa."Tipo de miembro" := Rec."Tipo de miembro";
            Miembroscooperativa."Tipo de aporte" := Rec."Tipo de aporte";
            Miembroscooperativa.Importe := Rec.Importe;
            Miembroscooperativa."Fecha inscripcion" := Rec."Fecha inscripcion";
            Miembroscooperativa."1ra Quincena" := Rec."1ra Quincena";
            Miembroscooperativa."2da Quincena" := Rec."2da Quincena";
            Miembroscooperativa.Status := Miembroscooperativa.Status::Activo;
            Miembroscooperativa.Insert;
        end;
        Message(Msg001);
    end;

    local procedure Salida()
    begin
        if (not Rec.Cesantia) and (not Rec.Preaviso) then
            if not Confirm(StrSubstNo(Msg004, Rec.FieldCaption("Tipo de accion"), Rec."Tipo de accion", Rec.FieldCaption(Cesantia), Rec.FieldCaption(Preaviso))) then
                Error(Err003);

        Emp.Get(Rec."No. empleado");
        Rec.TestField("Fecha efectividad");
        Cont.SetRange("No. empleado", Emp."No.");
        Cont.SetRange("Cód. contrato", Emp."Emplymt. Contract Code");
        Cont.FindFirst;
        Cont.Validate("Fecha finalización", Rec."Fecha efectividad");
        Cont."Pagar cesantia" := Rec.Cesantia;
        Cont."Pagar preaviso" := Rec.Preaviso;

        Cont.Validate(Finalizado, true);
        Cont.Modify;
        HistAccionesdepersonal.TransferFields(Rec);
        HistAccionesdepersonal."No. empleado" := Emp."No.";
        HistAccionesdepersonal.Insert(true);
        Rec.Delete;
        Message(Msg001);
    end;

    local procedure Cambio()
    begin
        Emp.Get(Rec."No. empleado");
        if Rec."Nuevo cargo" <> Rec."Cargo actual" then begin
            PerfilSalarioxCargo.Reset;
            PerfilSalarioxCargo.SetRange("Puesto de Trabajo", Rec."Nuevo cargo");

            if not PerfilSalarioxCargo.FindFirst then
                Error(StrSubstNo(Err002, Rec."Nuevo cargo"));
        end;

        if Rec."Tipo de accion" = Rec."Tipo de accion"::Cambio then begin
            Emp.Validate("First Name", Rec."First Name");
            Emp.Validate("Middle Name", Rec."Middle Name");
            Emp.Validate("Last Name", Rec."Last Name");
            Emp.Validate("Second Last Name", Rec."Second Last Name");
            //Emp."Employment Date" := "Fecha efectividad";
        end;

        Emp.Validate(Company, EmpCotiza."Empresa cotizacion");

        if (Rec."Departamento actual" <> Rec."Departamento nuevo") and (Rec."Departamento nuevo" <> '') then
            Emp.Validate(Departamento, Rec."Departamento nuevo");

        if (Rec."Cargo actual" <> Rec."Nuevo cargo") and (Rec."Nuevo cargo" <> '') then begin
            Cargos.Get(Emp.Departamento, Rec."Nuevo cargo");
            Emp.Validate("Job Type Code", Rec."Nuevo cargo");

            if Cargos."Global Dimension 1 Code" <> '' then
                Emp.Validate("Global Dimension 1 Code", Cargos."Global Dimension 1 Code");
            if Cargos."Global Dimension 2 Code" <> '' then
                Emp.Validate("Global Dimension 2 Code", Cargos."Global Dimension 2 Code");
        end;

        if (Rec."Ubicacion actual" <> Rec."Ubicacion nueva") and (Rec."Ubicacion nueva" <> '') then
            Emp.Validate("Working Center", Rec."Ubicacion nueva");
        if (Rec."Tipo de contrato" <> '') and (Emp."Emplymt. Contract Code" <> Rec."Tipo de contrato") then
            Emp.Validate("Emplymt. Contract Code", Rec."Tipo de contrato");


        if (Rec."Numero cuenta nueva" <> Rec."Numero cuenta actual") and (Rec."Numero cuenta nueva" <> '') then begin
            Rec.TestField("Cod. Banco");
            Cuentas.Init;
            Cuentas.Validate("No. empleado", Emp."No.");
            Cuentas.Validate("Cod. Banco", Rec."Cod. Banco");
            Cuentas.Validate("Numero Cuenta", Rec."Numero cuenta nueva");
            if not Cuentas.Insert then
                Cuentas.Modify;
        end;

        if (xRec."Numero tarjeta" <> Rec."Numero tarjeta") and (Rec."Numero tarjeta" <> '') then begin
            Rec.TestField("Banco tarjeta");
            Rec.TestField("Fecha expiracion");
            Rec.TestField("Importe tarjeta");
            Cuentas.Init;
            Cuentas.Validate("No. empleado", Emp."No.");
            Cuentas.Validate("Cod. Banco", Rec."Banco tarjeta");
            Cuentas.Validate("Nro. tarjeta", Rec."Numero tarjeta");
            Cuentas."Fecha vencimiento" := Rec."Fecha expiracion";
            Cuentas.Importe := Rec."Importe tarjeta";
            if not Cuentas.Insert then
                Cuentas.Modify;
        end;

        if Tiposdeaccionespersonal.Suspension then begin
            Rec.TestField("Fecha final");
            Rec.TestField("Cause of Inactivity Code");
            Emp.Status := Emp.Status::Inactive;
            Emp."Calcular Nomina" := false;
            Emp."Inactive Date" := Rec."Fecha efectividad";
            Emp."Fecha reactivacion" := Rec."Fecha final";
        end;

        if Rec."Cod. Supervisor" <> '' then
            Emp.Validate("Cod. Supervisor", Rec."Cod. Supervisor");

        Emp.Modify;
        Commit;

        if StrLen(Format(Rec."Duracion contrato")) <> 0 then
            Cont.Duracion := Format(Rec."Duracion contrato");

        if Cont.Duracion <> '' then begin
            Cont.Reset;
            Cont.SetRange("Cód. contrato", Emp."Emplymt. Contract Code");
            Cont.SetRange("No. empleado", Emp."No.");
            Cont.FindFirst;
            Cont.Validate("Fecha inicio", Emp."Employment Date");
            Cont.Validate(Duracion, Format(Rec."Duracion contrato"));
            Cont.Modify;
        end;


        PerfSal.Reset;
        PerfSal.SetRange("No. empleado", Emp."No.");
        PerfSal.SetRange("Concepto salarial", ConfNominas."Concepto Sal. Base");
        PerfSal.FindFirst;
        PerfSal.Validate(Cantidad, 1);
        PerfSal.Validate(Importe, Rec."Sueldo Nuevo");
        PerfSal.Modify;

        HistAccionesdepersonal.TransferFields(Rec);
        HistAccionesdepersonal."No. empleado" := Emp."No.";
        if not HistAccionesdepersonal.Insert(true) then
            HistAccionesdepersonal.Modify;

        InsertaSelBeneficios;

        if (Rec."Sueldo actual" <> Rec."Sueldo Nuevo") and (Rec."Sueldo Nuevo" <> 0) then begin
            HistSalario2.Reset;
            HistSalario2.SetRange("No. empleado", Emp."No.");
            if HistSalario2.FindLast then begin
                HistSalario.Init;
                HistSalario."No. empleado" := Emp."No.";
                HistSalario."Fecha Desde" := Emp."Employment Date"; //OJO A PARTIR DE ULTIMO CAMBIO
                HistSalario."Fecha Hasta" := CalcDate('-1D', Rec."Fecha efectividad");
                HistSalario.Importe := Rec."Sueldo actual";
                if not HistSalario.Insert then
                    HistSalario.Modify;
            end
            else begin
                HistSalario.Init;
                HistSalario."No. empleado" := Emp."No.";
                HistSalario."Fecha Desde" := Emp."Employment Date";
                HistSalario."Fecha Hasta" := CalcDate('-1D', Rec."Fecha efectividad");
                HistSalario.Importe := Rec."Sueldo actual";
                HistSalario.Insert;
            end;
        end;

        Rec.Delete;
        Message(Msg001);
    end;

    local procedure Transferencia()
    begin
        Rec.TestField("Empresa nueva");

        //TraspasaEmpleados("Empresa nueva");
        HistAccionesdepersonal.TransferFields(Rec);
        HistAccionesdepersonal."No. empleado" := Emp."No.";
        HistAccionesdepersonal.Insert(true);

        Emp.Get(Rec."No. empleado");
        Emp."Calcular Nomina" := false;
        Emp.Modify;

        Cont.Reset;
        Cont.SetRange("No. empleado", Emp."No.");
        Cont.SetRange("Cód. contrato", Emp."Emplymt. Contract Code");
        Cont.SetRange(Activo, true);
        Cont.FindFirst;
        Cont.Validate("Fecha finalización", Rec."Fecha efectividad");
        Cont.Validate(Finalizado, true);
        Cont.Modify;

        Rec.Delete;
        Message(Msg001);
    end;

    local procedure InsertaSelBeneficios()
    var
        BeneficiosLab: Record "Beneficios laborales";
    begin
        Seleccionbeneficios.Reset;
        Seleccionbeneficios.SetRange("Cod. Empleado", Rec."No. empleado");
        Seleccionbeneficios.SetRange(Seleccionar, true);
        if Seleccionbeneficios.FindSet then
            repeat
                case Seleccionbeneficios."Tipo Beneficio" of
                    0:   //Ingresos
                        begin
                            PerfSal.Reset;
                            PerfSal.SetRange("No. empleado", Rec."No. empleado");
                            PerfSal.SetRange("Concepto salarial", Seleccionbeneficios.Codigo);
                            if PerfSal.FindFirst then begin
                                PerfSal.Validate(Cantidad, 1);
                                PerfSal.Validate(Importe, Seleccionbeneficios.Importe);
                                PerfSal.Modify;
                            end;
                        end
                    else begin
                        Beneficiosempleados.Init;
                        Beneficiosempleados."Tipo Beneficio" := Seleccionbeneficios."Tipo Beneficio";
                        Beneficiosempleados."Cod. Empleado" := Rec."No. empleado";
                        Beneficiosempleados.Codigo := Seleccionbeneficios.Codigo;
                        Beneficiosempleados.Descripcion := Seleccionbeneficios.Descripcion;
                        Beneficiosempleados.Importe := Seleccionbeneficios.Importe;
                        if not Beneficiosempleados.Insert then
                            Beneficiosempleados.Modify;
                    end;
                end;
            until Seleccionbeneficios.Next = 0
        else begin
            if BeneficiosLab.Find('-') then
                repeat
                    Seleccionbeneficios.Init;
                    Seleccionbeneficios."No. documento" := Rec."No.";
                    Seleccionbeneficios.Validate("Cod. Empleado", Rec."No. empleado");
                    Seleccionbeneficios.Validate(Codigo, BeneficiosLab.Codigo);
                    if Seleccionbeneficios.Insert(true) then;
                until BeneficiosLab.Next = 0;
        end;
    end;
}

#pragma implicitwith restore

