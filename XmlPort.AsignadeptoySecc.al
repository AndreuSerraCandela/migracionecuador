xmlport 58007 "Asigna depto y Secc"
{
    Direction = Import;
    Format = VariableText;

    schema
    {
        textelement(AsignaDeptoSecc)
        {
            tableelement(Integer; Integer)
            {
                XmlName = 'DepSec';
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
                textelement(Cargo)
                {
                }
                textelement(Ciudad)
                {
                }
                textelement(Basura)
                {
                }
                textelement(Tel1)
                {
                }
                textelement(Cel)
                {
                }
                textelement(Basura2)
                {
                }
                textelement(fecnac)
                {
                }
                textelement(sex)
                {
                }
                textelement(fecing)
                {
                }
                textelement(mail)
                {
                }
                textelement(Basura3)
                {
                }
                textelement(Basura4)
                {
                }
                textelement(ced)
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
                textelement(Basura5)
                {
                }
                textelement(TipoCta)
                {
                }
                textelement(ctaban)
                {
                }
                textelement(sueldo)
                {
                }
                textelement(Codcte)
                {
                }
                textelement(NSS)
                {
                }
                textelement(SubDepto)
                {
                }
                textelement(Depto)
                {
                }
                textelement(Basura6)
                {
                }
                textelement(tipoempl)
                {
                }
                textelement(Basura7)
                {
                }
                textelement(Basura8)
                {
                }
            }

            trigger OnAfterAssignVariable()
            begin

                if SubDepto <> '' then begin
                    if StrPos(SubDepto, ' ') <> 0 then
                        SubDepto := CopyStr(SubDepto, StrPos(SubDepto, ' ') + 1, 4)
                    else
                        if StrPos(SubDepto, '-') <> 0 then
                            SubDepto := CopyStr(SubDepto, StrPos(SubDepto, '-') + 1, 4)

                end;

                if StrPos(Depto, '-') <> 0 then
                    Depart.SetFilter(Descripcion, CopyStr(Depto, StrPos(Depto, '-') + 1, 3) + '*');
                Depart.FindFirst;

                Empl.Get(CodEmpl);
                Empl.Departamento := Depart.Codigo;

                if SubDepto <> '' then begin
                    SubDe.SetRange("Cod. Departamento", Depart.Codigo);
                    SubDe.SetFilter(Descripcion, '*' + SubDepto + '*');
                    SubDe.FindFirst;
                end;
                Empl."Sub-Departamento" := SubDe.Codigo;
                Empl.Modify;
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
        Depart: Record Departamentos;
        SubDe: Record "Sub-Departamentos";
}

