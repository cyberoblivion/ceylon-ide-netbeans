import com.redhat.ceylon.compiler.typechecker.tree {
    VisitorAdaptor,
    Tree
}
import com.redhat.ceylon.ide.netbeans.lang {
    NBCeylonParser
}

import java.lang {
    Class
}
import java.util {
    Set,
    Map,
    HashMap,
    Collections
}

import org.netbeans.modules.csl.api {
    SemanticAnalyzer,
    ColoringAttributes,
    OffsetRange
}
import org.netbeans.modules.parsing.spi {
    SchedulerEvent,
    Scheduler
}

"Provides additional syntax highlights based on the parser result (for annotations, ...)"
shared class CeylonSemanticAnalyzer()
        extends SemanticAnalyzer<NBCeylonParser.CeylonParserResult>() {
    
    shared actual void cancel() {}
    
    shared actual Map<OffsetRange,Set<ColoringAttributes>> highlights = HashMap<OffsetRange, Set<ColoringAttributes>>();
    
    shared actual Integer priority => 1;
    
    shared actual void run(NBCeylonParser.CeylonParserResult res, SchedulerEvent schedulerEvent) {
        highlights.clear();
        
        object extends VisitorAdaptor() {
            shared actual void visitAnnotation(Tree.Annotation annotation) {
                super.visitAnnotation(annotation);
                
                if (exists name = annotation.primary) {
                    value start = name.startIndex.intValue();
                    value end = name.endIndex.intValue();
                    value range = OffsetRange(start, end);
                    highlights.put(range, Collections.singleton(ColoringAttributes.\iANNOTATION_TYPE));
                }
            }
            
            shared actual void visitImportPath(Tree.ImportPath path) {
                super.visitImportPath(path);
                
                value start = path.startIndex.intValue();
                value end = path.endIndex.intValue();
                value range = OffsetRange(start, end);
                highlights.put(range, Collections.singleton(ColoringAttributes.\iCUSTOM1));
            }

            shared actual void visitQualifiedMemberExpression(Tree.QualifiedMemberExpression qme) {
                super.visitQualifiedMemberExpression(qme);
                
                if (exists p = qme.identifier) {
                    value start = p.startIndex.intValue();
                    value end = p.endIndex.intValue();
                    value range = OffsetRange(start, end);
                    highlights.put(range, Collections.singleton(ColoringAttributes.\iCUSTOM2));
                }
            }
        }.visitCompilationUnit(res.rootNode);

    }
    
    shared actual Class<out Scheduler> schedulerClass
            => Scheduler.\iEDITOR_SENSITIVE_TASK_SCHEDULER;
}
