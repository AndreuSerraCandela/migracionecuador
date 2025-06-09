page 56076 "Windows Login"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = User;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User Security ID"; rec."User Security ID")
                {
                }
                /*field("Name 2"; rec."Name 2") //No existe el campo en la table extension User Text[208] //Nomina
                {
                }*/
            }
        }
    }

    actions
    {
    }
}

