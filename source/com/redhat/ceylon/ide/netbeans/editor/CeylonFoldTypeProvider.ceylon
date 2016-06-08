import java.lang {
    Class
}
import java.util {
    Arrays,
    Collection
}

import org.netbeans.api.editor.fold {
    FoldType
}
import org.netbeans.spi.editor.fold {
    FoldTypeProvider
}

shared class CeylonFoldTypeProvider() satisfies FoldTypeProvider {
    
    shared actual Collection<FoldType> getValues(Class<out Object> type)
        => Arrays.asList(
            FoldType.\iimport, FoldType.codeBlock, FoldType.comment,
            FoldType.documentation, FoldType.nested
        );
    
    inheritable() => false;
}
