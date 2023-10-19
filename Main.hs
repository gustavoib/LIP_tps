import Parser

main :: IO ()
main = do
    let programa = "program ex ; b := 0 end"
    let arvore = prog (words programa)
    print arvore
    
