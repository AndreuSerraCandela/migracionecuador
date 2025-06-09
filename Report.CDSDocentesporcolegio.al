report 76426 "CDS Docentes por colegio"
{
    // 0009 CAT Eliminación de los ceros de la derecha del codigo CDS
    DefaultLayout = RDLC;
    RDLCLayout = './CDSDocentesporcolegio.rdlc';


    dataset
    {
        dataitem("Colegio - Docentes"; "Colegio - Docentes")
        {
            CalcFields = "Nombre colegio";
            DataItemTableView = SORTING("Pertenece al CDS", "Cod. Colegio", "Apellido paterno") WHERE("Pertenece al CDS" = CONST(true));
            RequestFilterFields = "Cod. Colegio";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(USERID; UserId)
            {
            }
            column(Cod__Colegio___________Nombre_colegio__________traerDistrito; "Cod. Colegio" + ' - ' + "Nombre colegio" + ' - ' + "Distrito colegio")
            {
            }
            column(texNombre; texNombre)
            {
            }
            column(TraerDescripcionCargo; TraerDescripcionCargo)
            {
            }
            column(Colegio___Docentes__Cod__Nivel_; "Cod. Nivel")
            {
            }
            column(Colegio___Docentes__Nombre_Promotor_; "Nombre Promotor")
            {
            }
            column(texSaludo; texSaludo)
            {
            }
            column(codCDS; codCDS)
            {
            }
            column(texDocumento; texDocumento)
            {
            }
            column(texTelefono1; texTelefono1)
            {
            }
            column(texTelefono2; texTelefono2)
            {
            }
            column(texEmail; texEmail)
            {
            }
            column(datFechaNac; datFechaNac)
            {
            }
            column("codAño"; codAño)
            {
            }
            column("COUNT"; Count)
            {
            }
            column(Colegio___DocentesCaption; Colegio___DocentesCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(texNombreCaption; texNombreCaptionLbl)
            {
            }
            column(TraerDescripcionCargoCaption; TraerDescripcionCargoCaptionLbl)
            {
            }
            column(Colegio___Docentes__Cod__Nivel_Caption; Colegio___Docentes__Cod__Nivel_CaptionLbl)
            {
            }
            column(Colegio___Docentes__Nombre_Promotor_Caption; FieldCaption("Nombre Promotor"))
            {
            }
            column(texSaludoCaption; texSaludoCaptionLbl)
            {
            }
            column(codCDSCaption; codCDSCaptionLbl)
            {
            }
            column(texDocumentoCaption; texDocumentoCaptionLbl)
            {
            }
            column(texTelefono1Caption; texTelefono1CaptionLbl)
            {
            }
            column(texTelefono2Caption; texTelefono2CaptionLbl)
            {
            }
            column(texEmailCaption; texEmailCaptionLbl)
            {
            }
            column(datFechaNacCaption; datFechaNacCaptionLbl)
            {
            }
            column("codAñoCaption"; codAñoCaptionLbl)
            {
            }
            column(Cod__Colegio___________Nombre_colegio__________traerDistritoCaption; Cod__Colegio___________Nombre_colegio__________traerDistritoCaptionLbl)
            {
            }
            column(COUNTCaption; COUNTCaptionLbl)
            {
            }
            column(Colegio___Docentes_Cod__Colegio; "Cod. Colegio")
            {
            }
            column(Colegio___Docentes_Cod__Local; "Cod. Local")
            {
            }
            column(Colegio___Docentes_Cod__Docente; "Cod. Docente")
            {
            }

            trigger OnAfterGetRecord()
            begin

                Clear(texSaludo);
                Clear(codCDS);
                Clear(texNombre);
                Clear(texDocumento);
                Clear(texTelefono1);
                Clear(texTelefono2);
                Clear(texEmail);
                Clear(datFechaNac);
                Clear(codAño);

                if recDocente.Get("Cod. Docente") then begin
                    if recSaludos.Get(recDocente."Salutation Code") then
                        texSaludo := recSaludos.Description;

                    //+0009
                    //codCDS := recDocente."Cod. CDS";
                    if recDocente."No." <> '' then
                        Evaluate(codCDS, recDocente."No.");
                    //-0009


                    texNombre := recDocente.GetApellidosNombre;
                    texDocumento := recDocente."Tipo documento" + ' ' + recDocente."Document ID";
                    texTelefono1 := recDocente."Phone No.";
                    texTelefono2 := recDocente."Mobile Phone No.";
                    texEmail := recDocente."E-Mail";
                    if (recDocente."Dia Nacimiento" <> 0) and (recDocente."Mes Nacimiento" <> 0) and (recDocente."Ano Nacimiento" <> 0) then
                        datFechaNac := DMY2Date(recDocente."Dia Nacimiento", recDocente."Mes Nacimiento", recDocente."Ano Nacimiento");
                    codAño := recDocente."Ano inscripcion CDS";
                end;
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
        recDocente: Record Docentes;
        recSaludos: Record Salutation;
        texSaludo: Text[30];
        codCDS: Integer;
        texNombre: Text[250];
        "codAño": Code[4];
        datFechaNac: Date;
        texDocumento: Text[60];
        texTelefono1: Text[30];
        texTelefono2: Text[30];
        texEmail: Text[80];
        Colegio___DocentesCaptionLbl: Label 'CDS Docentes por colegio';
        CurrReport_PAGENOCaptionLbl: Label 'Pág.';
        texNombreCaptionLbl: Label 'Nombre docente';
        TraerDescripcionCargoCaptionLbl: Label 'Cargo';
        Colegio___Docentes__Cod__Nivel_CaptionLbl: Label 'Cód. Nivel';
        texSaludoCaptionLbl: Label 'Saludo';
        codCDSCaptionLbl: Label 'Código CDS';
        texDocumentoCaptionLbl: Label 'Documento';
        texTelefono1CaptionLbl: Label 'Teléfono';
        texTelefono2CaptionLbl: Label 'Teléfono 2';
        texEmailCaptionLbl: Label 'Email';
        datFechaNacCaptionLbl: Label 'Fecha nac.';
        "codAñoCaptionLbl": Label 'Año CDS';
        Cod__Colegio___________Nombre_colegio__________traerDistritoCaptionLbl: Label 'Colegio:';
        COUNTCaptionLbl: Label 'Total general:';


    procedure TraerDescripcionCargo(): Text[100]
    var
        recDatAux: Record "Datos auxiliares";
    begin
        recDatAux.Reset;
        recDatAux.SetRange("Tipo registro", recDatAux."Tipo registro"::"Puestos de trabajo");
        recDatAux.SetRange(Codigo, "Colegio - Docentes"."Cod. Cargo");
        if recDatAux.FindFirst then
            exit(recDatAux.Descripcion);
    end;


    procedure FormatFechaNac()
    begin
    end;
}

