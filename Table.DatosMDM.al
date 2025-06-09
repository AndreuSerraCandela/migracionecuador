table 75001 "Datos MDM"
{
    Caption = 'Datos MDM';
    DrillDownPageID = "Datos MDM";
    LookupPageID = "Datos MDM";

    fields
    {
        field(1; Tipo; Option)
        {
            Caption = 'Tipo';
            OptionCaption = 'Tipo Producto,Soporte,Editora,Nivel,Plan Editorial,Autor,Ciclo,Linea,Asignatura,Grado,Sello,Edición,Estado,Campaña';
            OptionMembers = "Tipo Producto",Soporte,Editora,Nivel,"Plan Editorial",Autor,Ciclo,Linea,Asignatura,Grado,Sello,Edicion,Estado,"Campaña";
        }
        field(2; Codigo; Code[10])
        {
            Caption = 'Codigo';
        }
        field(3; Descripcion; Text[100])
        {
            Caption = 'Descripción';
        }
        field(4; "Codigo Relacionado"; Code[10])
        {
            Caption = 'Codigo Relacionado';
            TableRelation = IF (Tipo = CONST(Grado)) "Datos MDM".Codigo WHERE(Tipo = CONST(Ciclo))
            ELSE
            IF (Tipo = CONST(Ciclo)) "Datos MDM".Codigo WHERE(Tipo = CONST(Nivel));
        }
        field(5; Bloqueado; Boolean)
        {
            Caption = 'Bloqueado';
        }
    }

    keys
    {
        key(Key1; Tipo, Codigo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Codigo, Descripcion)
        {
        }
    }

    trigger OnDelete()
    begin
        SincronizaDatosAuxAPS(true);
    end;

    trigger OnInsert()
    begin
        SincronizaDatosAuxAPS(false);
    end;

    trigger OnModify()
    begin
        SincronizaDatosAuxAPS(false);
    end;


    procedure SincronizaDatosAuxAPS(pwBorra: Boolean)
    var
        lwEnc: Boolean;
        lrDatAux: Record "Datos auxiliares";
        lrNivelEd: Record "Nivel Educativo";
        lwIdAPS: Integer;
    begin
        // SincronizaDatosAuxAPS
        // JPT 16/08/17
        // Sincroniza la información con la tabla "Datos Auxiliares" del módulo APS
        // Esta función debe de eliminarse cuando no se utilice el modulo APS


        lwIdAPS := -1;
        case Tipo of
            Tipo::Grado:
                lwIdAPS := lrDatAux."Tipo registro"::Grados;
            Tipo::Nivel:
                begin // Nivel educativo APS

                    lwEnc := lrNivelEd.Get(Codigo);

                    if pwBorra then begin
                        if lwEnc then
                            lrNivelEd.Delete(true);
                    end
                    else begin
                        if not lwEnc then begin
                            Clear(lrNivelEd);
                            lrNivelEd.Código := Codigo;
                        end;
                        lrNivelEd.Descripción := Descripcion;
                        if lwEnc then
                            lrNivelEd.Modify(true)
                        else
                            lrNivelEd.Insert(true);
                    end;
                end;
            else
                exit;
        end;


        if lwIdAPS = -1 then
            exit;

        lwEnc := lrDatAux.Get(lwIdAPS, Codigo);

        if pwBorra then begin
            if lwEnc then
                lrDatAux.Delete(true);
        end
        else begin
            if not lwEnc then begin
                Clear(lrDatAux);
                lrDatAux."Tipo registro" := lwIdAPS;
                lrDatAux.Codigo := Codigo;
            end;
            lrDatAux.Descripcion := Descripcion;
            if lwEnc then
                lrDatAux.Modify(true)
            else
                lrDatAux.Insert(true);
        end;
    end;


    procedure TotalTipos(): Integer
    begin
        // TotalTipos
        // Devuelve la cantidad de tipos distintos

        exit(14);
    end;
}

