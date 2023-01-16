#|
Author: David Zalewski 1215324552
Date:2/28/21
Description: Assignment 2; 5 parts; Part 1 make-2-n-list takes a num param and builds a list from 2 to that param; Part 2 divisible-by? returns true if num1 is divisible by num2, and false if not or they are equal;
Part3 not-divisible-by creates a curry function out of divisible-by?, true if not divisible and vice versa; Part 4 filter-list takes a function and list as param and returns the list of all elements that are true when passed into
the function. Part 5 combines all parts to make a Sieve of Eratosthenes
|#


;Part 1:
(define make-helper (lambda (endnum) (if(= endnum 2)  ; basecase: if endnum = 2 STOP
                                          '(2)    
                                          (list (make-helper (- endnum 1)) endnum))  ;recursive case: makes lists from 2-endnum and puts into one list. Ex: (make-helper 6) = ((((2 3) 4) 5) 6)

                      ))



(define make-helper-2 (lambda (make-helper) (if (eqv? (car make-helper) 2) ;basecase: if (car list) == 2, return list
                                                make-helper
                                                (append (make-helper-2 (car make-helper)) (cdr make-helper))) ; recursive case: appends (car list) + (cdr list) Ex: ((2 3) 4) --becomes---> (2 3 4)
                )) ;end define

(define make-2-n-list (lambda (endnum) ( make-helper-2 (make-helper endnum) ;combines helper methods make-helper and make-helper to create a list from 2-endnum
                                  )
                          ))


;Part 2:
(define divisible-by? (lambda (num1 num2) (cond ((= num1 num2)  ;if num1 = num2
                                                 #f ;return false
                                                 )
                                                ((= (modulo num1 num2) 0) ; if num1 % num2 = 0  (aka is divisible)
                                                 #t ;return true
                                                 )
                                                (else ; if not divisible and not equal
                                                 #f ;return false
                                                 )
                                           );end cond
                       ))

;Part 3:
(define not-divisible-by (lambda (divisor) ; ex: ((not-divisible-by 2) 10 ) -> #f
                           (lambda (dividend) (if (divisible-by? dividend divisor) ;if dividend is divisible by divisor
                                                  #f  ;return false
                                                  #t); return true
                            );end second funct
                          ))

;Part 4:

(define filter-list (lambda (input-funct list-param) (if (= (length list-param) 1)
                                                         (if (input-funct (car list-param)) ; When length of list == 1 : if function of final list-param element == #t
                                                             list-param ;return last element
                                                             '();return empty list (remove last element)
                                                             );end if
                                                         (if (input-funct (car list-param)); When length of list != 1 : if function of current list-param element == #t
                                                             (cons (car list-param) (filter-list input-funct (cdr list-param))) ;add current element to function of rest of list-param
                                                             (append '() (filter-list input-funct (cdr list-param))) ;remove current element, function of rest of list-param
                                                             );end if
                                                      );end first if
                      ))

;Part 5:
(define sieve-helper (lambda (divisible-num list-param sqrt-max) (if (> divisible-num sqrt-max) ;check if divisible-num is > sqrt(max primes)
                                                                     list-param ; num > sqrt-max, so STOP recursion; the base case
                                                                     (sieve-helper (+ divisible-num 1) (filter-list (not-divisible-by divisible-num) list-param) sqrt-max);num is not > sqrt-max, so remove all numbers divisble by divisible-num from current list. ; the recursive case
                                                                     )
                      ))

(define prime-sieve (lambda (max-primes) (sieve-helper 2 (make-2-n-list max-primes) (sqrt max-primes) ; performs sieve-helper starting with divisible num = 2, a new list 2-n, and sqrt of n
                                          )
                     ))

