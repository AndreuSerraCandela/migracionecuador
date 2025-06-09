page 50121 "Config. Serie Fiscal SIC"
{
    ApplicationArea = all;
    PageType = ListPart;
    SourceTable = "Serie Fiscal SIC";
    SourceTableView = ORDER(Descending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Sucursal; rec.Sucursal)
                {
                }
                field("Caja ID"; rec."Caja ID")
                {
                }
                field(IDNCF; rec.IDNCF)
                {
                }
                field("NCF FISCAL"; rec."NCF FISCAL")
                {
                }
                field(SIGLAS; rec.SIGLAS)
                {
                }
                field(INICIAL; rec.INICIAL)
                {
                }
                field(FINAL; rec.FINAL)
                {
                }
                field("FECHA CADUCIDAD"; rec."FECHA CADUCIDAD")
                {
                }
                field(ADVEERTENCIA; rec.ADVEERTENCIA)
                {
                }
                field(PROXIMO; rec.PROXIMO)
                {
                }
            }
        }
    }

    actions
    {
    }
}

